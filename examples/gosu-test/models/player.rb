require_relative 'general_object.rb'

class Player < GeneralObject
  Speed = 7
  MAX_ATTACK_SPEED = 3.0
  attr_accessor :cooldown_wait, :secondary_cooldown_wait, :attack_speed, :health, :armor, :x, :y, :rockets, :score, :time_alive, :bombs, :secondary_weapon
  MAX_HEALTH = 200

  SECONDARY_WEAPONS = %w[missile bomb]

  def take_damage damage
    @health -= damage
  end

  def toggle_secondary
    current_index = SECONDARY_WEAPONS.index(@secondary_weapon)
    if current_index == SECONDARY_WEAPONS.count - 1
      @secondary_weapon = SECONDARY_WEAPONS[0]
    else
      @secondary_weapon = SECONDARY_WEAPONS[current_index + 1]
    end
  end

  def get_secondary_ammo_count
    return case @secondary_weapon
    when 'bomb'
      self.bombs
    else
      self.rockets
    end
  end


  def decrement_secondary_ammo_count
    return case @secondary_weapon
    when 'bomb'
      self.bombs -= 1
    else
      self.rockets -= 1
    end
  end

  def get_secondary_name
    return case @secondary_weapon
    when 'bomb'
      'Bomb'
    else
      'Rocket'
    end
  end

  def initialize(x, y)
    # image = Magick::Image::read("#{MEDIA_DIRECTORY}/spaceship.png").first.resize(0.3)
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = Gosu::Image.new("#{MEDIA_DIRECTORY}/spaceship.png")
    # @beep = Gosu::Sample.new("#{MEDIA_DIRECTORY}/beep.wav")
    @x, @y = x, y
    @score = 0
    @cooldown_wait = 0
    @secondary_cooldown_wait = 0
    @attack_speed = 1
    @health = 100
    @armor = 0
    @rockets = 25
    # @rocket_launcher = {}
    @bombs = 3
    @time_alive = 0
    @secondary_weapon = "missile"
  end

  def get_x
    @x
  end
  def get_y
    @y
  end

  def is_alive
    health > 0
  end

  def move_left
    @x = [@x - Speed, (@image.width/3)].max
  end
  
  def move_right
    @x = [@x + Speed, (WIDTH - (@image.width/3))].min
  end
  
  def accelerate
    @y = [@y - Speed, (@image.height/2)].max
  end
  
  def brake
    @y = [@y + Speed, HEIGHT].min
  end


  def attack mouse_x = nil, mouse_y = nil
    return {
      projectiles: [Bullet.new(self, mouse_x, mouse_y, {side: 'left'}), Bullet.new(self, mouse_x, mouse_y, {side: 'right'})],
      cooldown: Bullet::COOLDOWN_DELAY
    }
  end

  def trigger_secondary_attack mouse_x, mouse_y
    return_projectiles = []
    if self.secondary_cooldown_wait <= 0 && self.get_secondary_ammo_count > 0
      results = self.secondary_attack(mouse_x, mouse_y)
      projectiles = results[:projectiles]
      cooldown = results[:cooldown]
      self.secondary_cooldown_wait = cooldown.to_f.fdiv(self.attack_speed)

      projectiles.each do |projectile|
        self.decrement_secondary_ammo_count
        return_projectiles.push(projectile)
      end
    end
    return return_projectiles
  end

  # def toggle_state_secondary_attack
  #   second_weapon = case @secondary_weapon
  #   when 'bomb'
  #   else
  #   end
  #   return second_weapon
  # end

  def secondary_attack mouse_x = nil, mouse_y = nil
    second_weapon = case @secondary_weapon
    when 'bomb'
      {
        projectiles: [Bomb.new(self, mouse_x, mouse_y)],
        cooldown: Bomb::COOLDOWN_DELAY
      }
    else
      if get_secondary_ammo_count > 1
        {
          projectiles: [Missile.new(self, mouse_x, mouse_y, {side: 'left'}), Missile.new(self, mouse_x, mouse_y, {side: 'right'})],
          cooldown: Missile::COOLDOWN_DELAY
        }
      else get_secondary_ammo_count == 1
        {
          projectiles: [Missile.new(self, mouse_x, mouse_y)],
          cooldown: Missile::COOLDOWN_DELAY
        }
      end
    end
    return second_weapon
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
  end
  
  def update
    self.cooldown_wait -= 1 if self.cooldown_wait > 0
    self.secondary_cooldown_wait -= 1 if self.secondary_cooldown_wait > 0
    @time_alive += 1 if self.is_alive
  end

  # def collect_stars(stars)
  #   stars.reject! do |star|
  #     if Gosu.distance(@x, @y, star.x, star.y) < 35
  #       @score += 10
  #       @attack_speed = @attack_speed + 0.1
  #       @attack_speed = MAX_ATTACK_SPEED if @attack_speed > MAX_ATTACK_SPEED

  #       # stop that!
  #       # @beep.play
  #       true
  #     else
  #       false
  #     end
  #   end
  # end


  def collect_pickups(pickups)
    pickups.reject! do |pickup|
      if Gosu.distance(@x, @y, pickup.x, pickup.y) < 35 && pickup.respond_to?(:collected_by_player)
        pickup.collected_by_player(self)
        if pickup.respond_to?(:get_points)
          self.score += pickup.get_points
        end
        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end



end