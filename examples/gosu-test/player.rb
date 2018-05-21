require_relative 'bullet.rb'
require_relative 'missile.rb'

class Player
  Speed = 7
  MAX_ATTACK_SPEED = 3.0
  attr_reader :score
  attr_accessor :cooldown_wait, :secondary_cooldown_wait, :attack_speed, :health, :armor, :x, :y, :rockets

  def initialize(x, y)
    # @image = Gosu::Image.new("media/spaceship.png", :tileable => true)
    # Magick::Image.new(2 * RADIUS, 2 * RADIUS) { self.background_color = 'none' }
    # image = Magick::Image::read("media/spaceship.png").first.resize(0.5)
    # image = Magick::Image::read("media/starfighter.bmp").first
    image = Magick::Image::read("media/spaceship.png").first.resize(0.3)

    # img = Magick::Image.new(columns. rows) {self.background_color = Magick::Pixel.new(rr, gg, bb, Magick::MaxRGB/2)}
    # puts "image:"
    # puts image.inspect
    # puts image.background_color
    # image.write("media/spaceship-result.png") do
    #   self.background_color = 'purple'
    # end

    @image = Gosu::Image.new(image, :tileable => true)
    @beep = Gosu::Sample.new("media/beep.wav")
    @x, @y = x, y
    @score = 0
    @cooldown_wait = 0
    @secondary_cooldown_wait = 0
    @attack_speed = 1
    @health = 100
    @armor = 0
    @rockets = 25
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

  def get_height
    @image.height
  end

  def get_width
    @image.width
  end

  def move_left
    @x = [@x - Speed, 0].max
  end
  
  def move_right
    @x = [@x + Speed, WIDTH].min
  end
  
  def accelerate
    @y = [@y - Speed, 50].max
  end
  
  def brake
    @y = [@y + Speed, HEIGHT].min
  end


  def attack mouse_x = nil, mouse_y = nil
    return {
      projectiles: [Bullet.new(self, 'left'), Bullet.new(self, 'right')],
      cooldown: Bullet::COOLDOWN_DELAY
    }
  end

  def secondary_attack mouse_x = nil, mouse_y = nil
    return {
      projectiles: [Missile.new(self, mouse_x, mouse_y)],
      cooldown: Missile::COOLDOWN_DELAY
    }
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
  end
  
  def update
    self.cooldown_wait -= 1 if self.cooldown_wait > 0
    self.secondary_cooldown_wait -= 1 if self.secondary_cooldown_wait > 0
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        @attack_speed = @attack_speed + 0.1
        @attack_speed = MAX_ATTACK_SPEED if @attack_speed > MAX_ATTACK_SPEED

        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end


  def collect_pickups(pickups)
    pickups.reject! do |pickup|
      if Gosu.distance(@x, @y, pickup.x, pickup.y) < 35
        pickup.collected_by_player(self) if pickup.respond_to?(:collected_by_player)

        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end



end