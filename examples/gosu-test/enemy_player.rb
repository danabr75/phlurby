require_relative 'player.rb'
require_relative 'enemy_bullet.rb'
require_relative 'small_explosion.rb'

class EnemyPlayer < Player
  Speed = 3
  MAX_ATTACK_SPEED = 3.0
  attr_reader :score
  attr_accessor :cooldown_wait, :attack_speed, :health, :armor, :x, :y

  def initialize(x = nil, y = nil)
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = x || rand(WIDTH)
    @y = y || 0
    @score = 0
    @cooldown_wait = 0
    @attack_speed = 0.5
    @health = 15
    @armor = 0
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


  def drop
    SmallExplosion.new(@x, @y)
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
  end

  def update
    # @y += 3
    if is_alive
      if rand(2).even?
        @y += rand(5)

        @y = HEIGHT / 2 if @y > HEIGHT / 2
      else
        @y -= rand(5)

        @y = 0 + @image.height if @y < 0 + @image.height
      end
      if rand(2).even?
        @x += rand(5)
        @x = WIDTH if @x > WIDTH
      else
        @x -= rand(5)
        @x = 0 + @image.width if @x < 0 + @image.width
      end


      @y < HEIGHT + @image.height
    else
      false
    end
  end
  
end