require_relative 'player.rb'
require_relative 'enemy_bullet.rb'
require_relative 'small_explosion.rb'
require_relative 'star.rb'

class EnemyPlayer < Player
  Speed = 3
  MAX_ATTACK_SPEED = 3.0
  POINT_VALUE_BASE = 10
  attr_reader :score
  attr_accessor :cooldown_wait, :attack_speed, :health, :armor, :x, :y

  def initialize(x = nil, y = nil)
    # image = Magick::Image::read("#{CURRENT_DIRECTORY}/media/starfighterv4.png").first
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/starfighterv4.png")
    # @beep = Gosu::Sample.new("#{CURRENT_DIRECTORY}/media/beep.wav")
    @x = x || rand(WIDTH)
    @y = y || 0
    @score = 0
    @cooldown_wait = 0
    @attack_speed = 0.5
    @health = 15
    @armor = 0
  end

  def get_points
    return POINT_VALUE_BASE
  end

  def is_alive
    @health > 0
  end


  def take_damage damage
    @health -= damage
  end

  def attack
    return {
      projectiles: [EnemyBullet.new(self)],
      cooldown: EnemyBullet::COOLDOWN_DELAY
    }
  end


  def drops
    [
      SmallExplosion.new(@x, @y),
      Star.new(@x, @y)
    ]
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Enemy)
  end

  def update player
    # @y += 3
    if is_alive
      # Stay above the player
      if player.is_alive && player.y < @y
          @y -= rand(5)
      else
        if rand(2).even?
          @y += rand(5)

          @y = HEIGHT / 2 if @y > HEIGHT / 2
        else
          @y -= rand(5)

          @y = 0 + (@image.height / 2) if @y < 0 + (@image.height / 2)
        end
      end
      if rand(2).even?
        @x += rand(5)
        @x = WIDTH if @x > WIDTH
      else
        @x -= rand(5)
        @x = 0 + (@image.width / 2) if @x < 0 + (@image.width / 2)
      end


      @y < HEIGHT + (@image.height / 2)
    else
      false
    end
  end
  
end