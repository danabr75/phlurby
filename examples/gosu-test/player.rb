class Player
  Speed = 7
  MAX_ATTACK_SPEED = 3.0
  attr_reader :score
  attr_accessor :cooldown_wait, :attack_speed, :health, :armor, :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x, @y = x, y
    @score = 0
    @cooldown_wait = 0
    @attack_speed = 1
    @health = 100
    @armor = 0
  end

  def get_x
    @x
  end
  def get_y
    @y
  end

  def is_alive
    health >= 0
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

  def attack animation, player
    return [
      Bullet.new(animation, player, 'left'),
      Bullet.new(animation, player, 'right')
    ]
  end
  
  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
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
end