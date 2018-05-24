# A simple "Triangle Game" that allows you to move a Roguelike '@' around the
# window (and off of it). This is a working example on MacOS 10.12 as of Dec 16, 2017.
# This combines some of the Ruby2D tutorial code with keypress management
# that actually works.
# 
# Keys: hjkl: movement, q: quit
# 
# To run: ruby triangle-game.rb after installing the Simple2D library and Ruby2D Gem.
#
# Author: Douglas P. Fields, Jr.
# E-mail: symbolics@lisp.engineer
# Site: https://symbolics.lisp.engineer/
# Copyright 2017 Douglas P. Fields, Jr.
# License: The MIT License

# require 'gosu'

# Encoding: UTF-8

# The tutorial game over a landscape rendered with OpenGL.
# Basically shows how arbitrary OpenGL calls can be put into
# the block given to Window#gl, and that Gosu Images can be
# used as textures using the gl_tex_info call.

# require 'rubygems'
require 'gosu'
# require 'opengl'
require_relative 'lib/opengl.rb'
# require 'rmagick'
require_relative 'star.rb'
require_relative 'bullet.rb'
require_relative 'enemy_bullet.rb'
require_relative 'missile.rb'
require_relative 'player.rb'
require_relative 'enemy_player.rb'
require_relative 'cursor.rb'
require_relative 'building.rb'
require_relative 'grappling_hook.rb'

# exit if Object.const_defined?(:Ocra) #allow ocra to create an exe without executing the entire script


WIDTH, HEIGHT = 640, 480

module ZOrder
  Background, Building, Cursor, Bullets, SmallExplosions, BigExplosions, Pickups, Enemy, Player, UI = *0..10
end

# The only really new class here.
# Draws a scrolling, repeating texture with a randomized height map.
class GLBackground
  # Height map size
  POINTS_X = 7
  POINTS_Y = 7
  # Scrolling speed
  SCROLLS_PER_STEP = 50
  # TEMP USING THIS, CANNOT FIND SCROLLING SPEED
  SCROLLING_SPEED = 4

  def initialize
    @image = Gosu::Image.new("media/earth.png", :tileable => true)
    @scrolls = 0
    @height_map = Array.new(POINTS_Y) { Array.new(POINTS_X) { rand } }
  end
  
  def scroll
    @scrolls += 1
    if @scrolls == SCROLLS_PER_STEP
      @scrolls = 0
      @height_map.shift
      @height_map.push Array.new(POINTS_X) { rand }
    end
  end
  
  def draw(z)
    # gl will execute the given block in a clean OpenGL environment, then reset
    # everything so Gosu's rendering can take place again.
    Gosu.gl(z) { exec_gl }
  end
  
  private
  
  include Gl
  
  def exec_gl
    glClearColor(0.0, 0.2, 0.5, 1.0)
    glClearDepth(0)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    
    # Get the name of the OpenGL texture the Image resides on, and the
    # u/v coordinates of the rect it occupies.
    # gl_tex_info can return nil if the image was too large to fit onto
    # a single OpenGL texture and was internally split up.
    info = @image.gl_tex_info
    return unless info

    # Pretty straightforward OpenGL code.
    
    glDepthFunc(GL_GEQUAL)
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_BLEND)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    glFrustum(-0.10, 0.10, -0.075, 0.075, 1, 100)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity
    glTranslate(0, 0, -4)
  
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, info.tex_name)
    
    offs_y = 1.0 * @scrolls / SCROLLS_PER_STEP
    
    0.upto(POINTS_Y - 2) do |y|
      0.upto(POINTS_X - 2) do |x|
        glBegin(GL_TRIANGLE_STRIP)
          z = @height_map[y][x]
          glColor4d(1, 1, 1, z)
          glTexCoord2d(info.left, info.top)
          glVertex3d(-0.5 + (x - 0.0) / (POINTS_X-1), -0.5 + (y - offs_y - 0.0) / (POINTS_Y-2), z)

          z = @height_map[y+1][x]
          glColor4d(1, 1, 1, z)
          glTexCoord2d(info.left, info.bottom)
          glVertex3d(-0.5 + (x - 0.0) / (POINTS_X-1), -0.5 + (y - offs_y + 1.0) / (POINTS_Y-2), z)
        
          z = @height_map[y][x + 1]
          glColor4d(1, 1, 1, z)
          glTexCoord2d(info.right, info.top)
          glVertex3d(-0.5 + (x + 1.0) / (POINTS_X-1), -0.5 + (y - offs_y - 0.0) / (POINTS_Y-2), z)

          z = @height_map[y+1][x + 1]
          glColor4d(1, 1, 1, z)
          glTexCoord2d(info.right, info.bottom)
          glVertex3d(-0.5 + (x + 1.0) / (POINTS_X-1), -0.5 + (y - offs_y + 1.0) / (POINTS_Y-2), z)
        glEnd
      end
    end
  end
end


class OpenGLIntegration < Gosu::Window

  # def button_down(id)
  #   puts "HERE: #{id.inspect}"
  #   super(id)
  # end

  def initialize
    super WIDTH, HEIGHT
    
    self.caption = "OpenGL Integration"
    
    @gl_background = GLBackground.new
    
    @player = Player.new(400, 500)
    @grappling_hook = nil
    
    # @star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    # @projectile_anim = Gosu::Image::load_tiles("media/projectile.png", 25, 25)
    # @projectile_anim = Gosu::Image::load_tiles("media/projectile.png", 25, 25)
    # @projectile_anim = Gosu::Image.new("media/projectile-mini.png")
    # puts "star_anim size: #{@star_anim.size}"
    # puts "projectile_anim size: #{@projectile_anim.size}"
    # @stars = Array.new
    @buildings = Array.new
    @projectiles = Array.new
    @enemy_projectiles = Array.new
    @pickups = Array.new

    @enemies = Array.new
    @enemies_random_spawn_timer = 100
    
    @font = Gosu::Font.new(20)
    @max_enemies = 4

    # @cursor = Gosu::Image.new(self, 'media/crosshair.png')
    # @pointer = Gosu::Image.new(self,"media/crosshair.png")

    # pointer = Magick::Image::read("media/crosshair.png").first.resize(0.3)
    # @pointer = Gosu::Image.new(pointer, :tileable => true)

    @pointer = Cursor.new
    # @pointer = Gosu::Image.new("media/bullet-mini.png")
    # @px = 0
    # @py = 0
  end

  # def update
  #   @px = mouse_x # this method returns the x coordinate of the mouse
  #   @py = mouse_y # this method returns the y coordinate of the mouse
  # end
  
  # def draw
  #   @pointer.draw(@px,@py,0) # we're drawing the mouse at the current position
  # end

  # def needs_cursor?
  #   true
  # end
  
  def update
    # @px = self.mouse_x # this method returns the x coordinate of the mouse
    # @py = self.mouse_y # this method returns the y coordinate of the mouse
    # puts "PX: #{@px} - PY: #{@py}"

    if Gosu.button_down?(Gosu::KB_Q)
      close!
    end

    if @player.is_alive
      @player.update
      @player.move_left  if Gosu.button_down?(Gosu::KB_LEFT)  || Gosu.button_down?(Gosu::GP_LEFT)    || Gosu.button_down?(Gosu::KB_A)
      @player.move_right if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::GP_RIGHT)   || Gosu.button_down?(Gosu::KB_D)
      @player.accelerate if Gosu.button_down?(Gosu::KB_UP)    || Gosu.button_down?(Gosu::GP_UP)      || Gosu.button_down?(Gosu::KB_W)
      @player.brake      if Gosu.button_down?(Gosu::KB_DOWN)  || Gosu.button_down?(Gosu::GP_DOWN)    || Gosu.button_down?(Gosu::KB_S)

      if Gosu.button_down?(Gosu::MS_RIGHT)
        if @grappling_hook == nil
          @grappling_hook = GrapplingHook.new(@player)
        end
      end

      # Gosu::Window#button_up
      def button_up id
        # super
        if (id == Gosu::MS_RIGHT)
          # puts "MOUSE CLICK"
          # @grappling_hook = nil
          @grappling_hook.deactivate if @grappling_hook
        end
      end
      # if button_up?(Gosu::MS_RIGHT)
      #   # puts "MOUSE CLICK"
      #   @grappling_hook = nil
      # end


      if Gosu.button_down?(Gosu::MS_LEFT)
        # puts "MOUSE CLICK"
        if @player.secondary_cooldown_wait <= 0 && @player.rockets > 0
          results = @player.secondary_attack(self.mouse_x, self.mouse_y)
          projectiles = results[:projectiles]
          cooldown = results[:cooldown]
          @player.secondary_cooldown_wait = cooldown.to_f.fdiv(@player.attack_speed)

          projectiles.each do |projectile|
            @player.rockets -= 1
            @projectiles.push(projectile)
          end
        end
      end

      if Gosu.button_down?(Gosu::KB_SPACE)
        if @player.cooldown_wait <= 0
          results = @player.attack(self.mouse_x, self.mouse_y)
          projectiles = results[:projectiles]
          cooldown = results[:cooldown]
          @player.cooldown_wait = cooldown.to_f.fdiv(@player.attack_speed)

          projectiles.each do |projectile|
            @projectiles.push(projectile)
          end
        end
      end
      
      # @player.collect_stars(@stars)
      @player.collect_pickups(@pickups)

      @enemy_projectiles.each do |projectile|
        # projectile.hit_stars(@stars)
        hit_player = projectile.hit_object(@player)
        if hit_player > 0
          # puts "hit_player: #{hit_player}"
          @player.health -= hit_player
        end
      end


      @grappling_hook.collect_pickups(@player, @pickups) if @grappling_hook && @grappling_hook.active
    end

    @projectiles.each do |projectile|
      # @pickups = @pickups + projectile.hit_objects(@stars)
      enemy_results = projectile.hit_objects(@enemies)
      @pickups = @pickups + enemy_results[:drops]
      @player.score += enemy_results[:point_value]
      building_results = projectile.hit_objects(@buildings)
      @pickups = @pickups + building_results[:drops]
      @player.score += building_results[:point_value]
    end


    
    
    # @stars.reject! { |star| !star.update }
    @buildings.reject! { |building| !building.update }

    if @player.is_alive && @grappling_hook
      grap_result = @grappling_hook.update(self.mouse_x, self.mouse_y, @player)
      puts "Setting grap to nil - #{grap_result}" if !grap_result
      @grappling_hook = nil if !grap_result
    end

    # @buildings.reject! do |building|
    #   results = building.update
    #   (results[:drops] || []).each do |drop|
    #     @pickups << drop
    #   end
    #   !results[:update]
    # end

    @pickups.reject! { |pickup| !pickup.update }

    @projectiles.reject! { |projectile| !projectile.update(self.mouse_x, self.mouse_y) }

    @enemy_projectiles.reject! { |projectile| !projectile.update(self.mouse_x, self.mouse_y) }
    @enemies.reject! { |enemy| !enemy.update }


    @gl_background.scroll
    
    # @stars.push(Star.new()) if rand(75) == 0

    # @buildings.push(Building.new()) if rand(500) == 0
    @buildings.push(Building.new()) if rand(100) == 0



    @enemies.push(EnemyPlayer.new()) if rand(@enemies_random_spawn_timer) == 0 && @enemies.count <= @max_enemies
    if @player.time_alive % 500 == 0
      @max_enemies += 1
    end
    if @player.time_alive % 1000 == 0 && @enemies_random_spawn_timer > 5
      @enemies_random_spawn_timer -= 5
    end

    # Move to enemy mehtods
    @enemies.each do |enemy|
      enemy.cooldown_wait -= 1 if enemy.cooldown_wait > 0
      if enemy.cooldown_wait <= 0
        results = enemy.attack
        projectiles = results[:projectiles]
        cooldown = results[:cooldown]
        enemy.cooldown_wait = cooldown.to_f.fdiv(enemy.attack_speed)

        projectiles.each do |projectile|
          @enemy_projectiles.push(projectile)
        end
      end
    end
  end

  # def scroll
  #   @buildings.reject! { |building| !building.update }
  # end

  def draw
    @pointer.draw(self.mouse_x, self.mouse_y) if @grappling_hook.nil? || !@grappling_hook.active

    @player.draw if @player.is_alive
    @grappling_hook.draw(@player) if @player.is_alive && @grappling_hook
    @font.draw("You are dead! Press Q to quit", WIDTH / 2 - 50, HEIGHT / 2 - 25, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if !@player.is_alive
    @enemies.each { |enemy| enemy.draw }
    @projectiles.each { |projectile| projectile.draw() }
    @enemy_projectiles.each { |projectile| projectile.draw() }
    # @stars.each { |star| star.draw }
    @pickups.each { |pickup| pickup.draw }
    @buildings.each { |building| building.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Attack Speed: #{@player.attack_speed.round(2)}", 10, 25, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Health: #{@player.health}", 10, 40, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Armor: #{@player.armor}", 10, 55, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Rockets: #{@player.rockets}", 10, 70, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Time Alive: #{@player.time_alive}", 10, 85, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @gl_background.draw(ZOrder::Background)
  end
end

OpenGLIntegration.new.show if __FILE__ == $0