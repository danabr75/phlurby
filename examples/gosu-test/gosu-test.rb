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

CURRENT_DIRECTORY = File.expand_path('../', __FILE__)
MEDIA_DIRECTORY   = File.expand_path('../', __FILE__) + "/media"

# ONLY ENABLE FOR WINDOWS COMPILATION
# Place opengl lib in lib library
# Replace the meths list iteration with the following (added rescue blocks):
  # meths.each do |mn|
  #   define_singleton_method(mn) do |*args,&block|
  #     begin
  #       implementation.send(mn, *args, &block)
  #     rescue
  #     end
  #   end
  #   define_method(mn) do |*args,&block|
  #     begin
  #       implementation.send(mn, *args, &block)
  #     rescue
  #     end
  #   end
  #   private mn
  # end
# For WINDOWS - using local lip
# require_relative 'lib/opengl.rb'
# FOR Linux\OSX - using opengl gem
require 'opengl'

Dir["#{CURRENT_DIRECTORY}/models/*.rb"].each { |f| require f }

# require_relative 'media'
# Dir["/path/to/directory/*.rb"].each {|file| require file }
# 
# exit if Object.const_defined?(:Ocra) #allow ocra to create an exe without executing the entire script


WIDTH, HEIGHT = 640, 480

RESOLUTIONS = [[640, 480], [800, 600], [960, 720], [1024, 768], [1280, 960], [1400, 1050], [1440, 1080], [1600, 1200], [1856, 1392], [1920, 1440], [2048, 1536]]
# RESOLUTIONS = [[640, 480], [800, 600], [960, 720], [1024, 768]]
# WIDTH, HEIGHT = 1080, 720

module ZOrder
  Background, Building, Cursor, Projectile, SmallExplosions, BigExplosions, Pickups, Enemy, Player, UI = *0..10
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
    @image = Gosu::Image.new("#{MEDIA_DIRECTORY}/earth.png", :tileable => true)
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
  attr_accessor :width, :height

  # def button_down(id)
  #   puts "HERE: #{id.inspect}"
  #   super(id)
  # end

  def self.reset(window)
    window = OpenGLIntegration.new.show
  end

# When fullscreen, try to match window with screen resolution
# .screen_height ⇒ Integer
# The height (in pixels) of the user's primary screen.
# .screen_width ⇒ Integer
# The width (in pixels) of the user's primary screen.

  def self.fullscreen(window)
    window.fullscreen = !window.fullscreen?
  end

  def self.resize(window, width, height, fullscreen)
    window = OpenGLIntegration.new(width, height).show
    window.fullscreen = fullscreen
  end

  def self.find_index_of_current_resolution width, height
    current_index = nil
    counter = 0
    RESOLUTIONS.each do |resolution|
      break if current_index && current_index > 0
      current_index = counter if resolution[0] == width && resolution[1] == height
      counter += 1
    end
    return current_index
  end

  def self.up_resolution(window)
    # puts "UP RESLUTION"
    index = find_index_of_current_resolution(window.width, window.height)
    # puts "FOUND INDEX: #{index}"
    if index == RESOLUTIONS.count - 1
      # Max resolution, do nothing
    else
      # window.width = RESOLUTIONS[index + 1][0]
      # window.height = RESOLUTIONS[index + 1][1]
      width = RESOLUTIONS[index + 1][0]
      height = RESOLUTIONS[index + 1][1]
      # puts "UPPING TO #{width} x #{height}"
      window = OpenGLIntegration.new(width, height, {block_resize: true}).show
    end
  end

  def self.down_resolution(window)
    index = find_index_of_current_resolution(window.width, window.height)
    if index == 0
      # Min resolution, do nothing
    else
      # window.width = RESOLUTIONS[index - 1][0]
      # window.height = RESOLUTIONS[index - 1][1]
      width = RESOLUTIONS[index - 1][0]
      height = RESOLUTIONS[index - 1][1]
      window = OpenGLIntegration.new(width, height, {block_resize: true}).show
    end
  end

  def initialize width = nil, height = nil, options = {}
    @width  = width || WIDTH
    @height = height || HEIGHT
    index = OpenGLIntegration.find_index_of_current_resolution(self.width, self.height)
    if index == 0
      @scale = 1
    else
      original_width, original_height = RESOLUTIONS[0]
      width_scale = @width / original_width.to_f
      height_scale = @height / original_height.to_f
      @scale = (width_scale + height_scale) / 2
    end
    super(@width, @height)
    
    @game_pause = false
    @can_pause = true
    @can_resize = !options[:block_resize].nil? && options[:block_resize] == true ? false : true
    @can_toggle_secondary = true
    @can_toggle_fullscreen_a = true
    @can_toggle_fullscreen_b = true

    self.caption = "OpenGL Integration"
    
    @gl_background = GLBackground.new
    
    @player = Player.new(@scale, @width / 2, @height / 2)
    @grappling_hook = nil
    
    # @star_anim = Gosu::Image::load_tiles("#{MEDIA_DIRECTORY}/star.png", 25, 25)
    # @projectile_anim = Gosu::Image::load_tiles("#{MEDIA_DIRECTORY}/projectile.png", 25, 25)
    # @projectile_anim = Gosu::Image::load_tiles("#{MEDIA_DIRECTORY}/projectile.png", 25, 25)
    # @projectile_anim = Gosu::Image.new("#{MEDIA_DIRECTORY}/projectile-mini.png")
    # puts "star_anim size: #{@star_anim.size}"
    # puts "projectile_anim size: #{@projectile_anim.size}"
    # @stars = Array.new
    @buildings = Array.new
    @projectiles = Array.new
    @enemy_projectiles = Array.new
    @pickups = Array.new

    @enemies = Array.new
    @enemies_random_spawn_timer = 100
    @enemies_spawner_counter = 0
    
    @font = Gosu::Font.new(20)
    @max_enemies = 4

    # @cursor = Gosu::Image.new(self, 'media/crosshair.png')
    # @pointer = Gosu::Image.new(self,"#{MEDIA_DIRECTORY}/crosshair.png")

    # pointer = Magick::Image::read("#{MEDIA_DIRECTORY}/crosshair.png").first.resize(0.3)
    # @pointer = Gosu::Image.new(pointer, :tileable => true)

    @pointer = Cursor.new(@scale)
    # @pointer = Gosu::Image.new("#{MEDIA_DIRECTORY}/bullet-mini.png")
    # @px = 0
    # @py = 0
    @ui_y = 10
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

    if Gosu.button_down?(Gosu::KbEscape)
      close!
    end

    # Gosu::Window#button_up
    def button_up id
      # puts "BUTTON_UP: #{id}"
      # super
      if (id == Gosu::MS_RIGHT) && @player.is_alive
        # puts "MOUSE CLICK"
        # @grappling_hook = nil
        @grappling_hook.deactivate if @grappling_hook
      end

      if (id == Gosu::KB_P)
        @can_pause = true
      end
      if (id == Gosu::KB_TAB)
        # puts "TAB UP"
        @can_toggle_secondary = true
      end

      if id == Gosu::KB_RETURN
        @can_toggle_fullscreen_a = true
      end
      if id == Gosu::KB_RIGHT_META
        @can_toggle_fullscreen_b = true
      end
      # puts "ID UP: #{id}"
      if id == Gosu::KB_MINUS
        @can_resize = true
      end
      if id == Gosu::KB_EQUALS
        @can_resize = true
      end
    end


    if Gosu.button_down?(Gosu::KB_M)
      OpenGLIntegration.reset(self)
    end



    # if Gosu.button_down?(Gosu::KB_RIGHT_META) && Gosu.button_down?(Gosu::KB_RETURN)
    #   # puts "HErE"
    #   # @can_toggle_fullscreen = 0
    #   # OpenGLIntegration.fullscreen(self)
    # end
    # if Gosu.button_down?(Gosu::KB_RIGHT_META)
    #   # puts "HErE1"
    #   # @can_toggle_fullscreen = 0
    #   # OpenGLIntegration.fullscreen(self)
    # end
    # if Gosu.button_down?(Gosu::KB_RETURN)
    #   # puts "HErE2"
    #   # @can_toggle_fullscreen = 0
    #   # OpenGLIntegration.fullscreen(self)
    # end


    if Gosu.button_down?(Gosu::KB_RIGHT_META) && Gosu.button_down?(Gosu::KB_RETURN) && @can_toggle_fullscreen_a && @can_toggle_fullscreen_b
      @can_toggle_fullscreen_a = false
      @can_toggle_fullscreen_b = false
      OpenGLIntegration.fullscreen(self)
    end


    if Gosu.button_down?(Gosu::KB_P) && @can_pause
      @can_pause = false
      # puts "GAME PAUSE: #{@game_pause}"
      @game_pause = !@game_pause
    end

    if Gosu.button_down?(Gosu::KB_O) && @can_resize
      @can_resize = false
      # puts "GAME PAUSE: #{@game_pause}"
      OpenGLIntegration.resize(self, 1920, 1080, false)
    end

    if Gosu.button_down?(Gosu::KB_MINUS) && @can_resize
      @can_resize = false
      # puts "GAME PAUSE: #{@game_pause}"
      OpenGLIntegration.down_resolution(self)
    end
    if Gosu.button_down?(Gosu::KB_EQUALS) && @can_resize
      # puts "INCREASE SIZE! - #{@can_resize}"
      @can_resize = false
      # puts "GAME PAUSE: #{@game_pause}"
      OpenGLIntegration.up_resolution(self)
    end


    if Gosu.button_down?(Gosu::KB_TAB) && @can_toggle_secondary
      # puts "TAB HERE"
      @can_toggle_secondary = false
      @player.toggle_secondary
    end

    if @player.is_alive && !@game_pause
      @player.update(@width, @height)
      @player.move_left(@width)  if Gosu.button_down?(Gosu::KB_LEFT)  || Gosu.button_down?(Gosu::GP_LEFT)    || Gosu.button_down?(Gosu::KB_A)
      @player.move_right(@width) if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::GP_RIGHT)   || Gosu.button_down?(Gosu::KB_D)
      @player.accelerate(@height) if Gosu.button_down?(Gosu::KB_UP)    || Gosu.button_down?(Gosu::GP_UP)      || Gosu.button_down?(Gosu::KB_W)
      @player.brake(@height)      if Gosu.button_down?(Gosu::KB_DOWN)  || Gosu.button_down?(Gosu::GP_DOWN)    || Gosu.button_down?(Gosu::KB_S)

      if Gosu.button_down?(Gosu::MS_RIGHT)
        if @grappling_hook == nil
          @grappling_hook = GrapplingHook.new(@scale, @player)
        end
      end




      # if Gosu.button_down?(Gosu::MS_LEFT)
      #   # puts "MOUSE CLICK"
      #   if @player.secondary_cooldown_wait <= 0 && @player.rockets > 0
      #     results = @player.secondary_attack(self.mouse_x, self.mouse_y)
      #     projectiles = results[:projectiles]
      #     cooldown = results[:cooldown]
      #     @player.secondary_cooldown_wait = cooldown.to_f.fdiv(@player.attack_speed)

      #     projectiles.each do |projectile|
      #       @player.rockets -= 1
      #       @projectiles.push(projectile)
      #     end
      #   end
      # end

      if Gosu.button_down?(Gosu::MS_LEFT)
        # puts "MOUSE CLICK"
        @projectiles = @projectiles + @player.trigger_secondary_attack(@width, @height, self.mouse_x, self.mouse_y)
      end

      if Gosu.button_down?(Gosu::KB_SPACE)
        if @player.cooldown_wait <= 0
          results = @player.attack(@width, @height, self.mouse_x, self.mouse_y)
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
        projectile.hit_object(@player)
        # results = 
        # if hit_player > 0
        #   # puts "hit_player: #{hit_player}"
        #   @player.health -= hit_player
        # end
      end


      @grappling_hook.collect_pickups(@player, @pickups) if @grappling_hook && @grappling_hook.active
    end

    if !@game_pause

      @projectiles.each do |projectile|
        results = projectile.hit_objects([@enemies, @buildings])
        # puts "RESULTS HERE: #{results}"
        @pickups = @pickups + results[:drops]
        @player.score += results[:point_value]
      end


      
      
      # @stars.reject! { |star| !star.update }
      @buildings.reject! { |building| !building.update(@width, @height) }

      if @player.is_alive && @grappling_hook
        grap_result = @grappling_hook.update(@width, @height, self.mouse_x, self.mouse_y, @player)
        # puts "Setting grap to nil - #{grap_result}" if !grap_result
        @grappling_hook = nil if !grap_result
      end

      # @buildings.reject! do |building|
      #   results = building.update
      #   (results[:drops] || []).each do |drop|
      #     @pickups << drop
      #   end
      #   !results[:update]
      # end

      @pickups.reject! { |pickup| !pickup.update(@width, @height, self.mouse_x, self.mouse_y) }

      @projectiles.reject! { |projectile| !projectile.update(@width, @height, self.mouse_x, self.mouse_y) }

      @enemy_projectiles.reject! { |projectile| !projectile.update(@width, @height, self.mouse_x, self.mouse_y) }
      @enemies.reject! { |enemy| !enemy.update(@width, @height, nil, nil, @player) }


      @gl_background.scroll
      
      # @stars.push(Star.new()) if rand(75) == 0

      # @buildings.push(Building.new()) if rand(500) == 0
      @buildings.push(Building.new(@scale)) if rand(100) == 0


      # @enemies.push(EnemyPlayer.new()) if @enemies.count == 0
      if @player.is_alive && rand(@enemies_random_spawn_timer) == 0 && @enemies.count <= @max_enemies
        (0..@enemies_spawner_counter).each do |count|
          @enemies.push(EnemyPlayer.new(@scale, @width, @height))
        end
      end
      if @player.time_alive % 500 == 0
        @max_enemies += 1
      end
      if @player.time_alive % 1000 == 0 && @enemies_random_spawn_timer > 5
        @enemies_random_spawn_timer -= 5
      end
      if @player.time_alive % 5000 == 0
        @enemies_spawner_counter += 1
      end

      if @player.time_alive % 1000 == 0 && @player.time_alive > 0
        @player.score += 100
      end


      # Move to enemy mehtods
      @enemies.each do |enemy|
        enemy.cooldown_wait -= 1 if enemy.cooldown_wait > 0
        if enemy.cooldown_wait <= 0
          results = enemy.attack(@width, @height)
          projectiles = results[:projectiles]
          cooldown = results[:cooldown]
          enemy.cooldown_wait = cooldown.to_f.fdiv(enemy.attack_speed)

          projectiles.each do |projectile|
            @enemy_projectiles.push(projectile)
          end
        end
      end
    end
  end

  # def scroll
  #   @buildings.reject! { |building| !building.update }
  # end

  def draw
    @pointer.draw(self.mouse_x, self.mouse_y) if @grappling_hook.nil? || !@grappling_hook.active

    @player.draw() if @player.is_alive
    @grappling_hook.draw(@player) if @player.is_alive && @grappling_hook
    @font.draw("You are dead!", @width / 2 - 50, @height / 2 - 55, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if !@player.is_alive
    @font.draw("Press ESC to quit", @width / 2 - 50, @height / 2 - 40, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if !@player.is_alive
    @font.draw("Press M to Restart", @width / 2 - 50, @height / 2 - 25, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if !@player.is_alive
    @font.draw("Paused", @width / 2 - 50, @height / 2 - 25, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if @game_pause
    @enemies.each { |enemy| enemy.draw() }
    @projectiles.each { |projectile| projectile.draw() }
    @enemy_projectiles.each { |projectile| projectile.draw() }
    # @stars.each { |star| star.draw }
    @pickups.each { |pickup| pickup.draw() }
    @buildings.each { |building| building.draw() }
    @font.draw("Score: #{@player.score}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    # @font.draw("Attack Speed: #{@player.attack_speed.round(2)}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Health: #{@player.health}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Armor: #{@player.armor}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    # @font.draw("Rockets: #{@player.rockets}", 10, 70, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if @player.secondary_weapon == 'missile'
    # @font.draw("Bombs: #{@player.bombs}", 10, 70, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if @player.secondary_weapon == 'bomb'
    @font.draw("Weapon: #{@player.get_secondary_name}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Rockets: #{@player.rockets}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Bombs: #{@player.bombs}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00) if @player.bombs > 0
    @font.draw("Time Alive: #{@player.time_alive}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Level: #{@enemies_spawner_counter + 1}", 10, get_font_ui_y, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @gl_background.draw(ZOrder::Background)
    reset_font_ui_y
  end

  def get_font_ui_y
    return_value = @ui_y
    @ui_y += 15 
    return return_value
  end
  def reset_font_ui_y
    @ui_y = 10
  end
end

OpenGLIntegration.new.show if __FILE__ == $0














