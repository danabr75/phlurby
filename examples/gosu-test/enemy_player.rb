require_relative 'player.rb'
require_relative 'enemy_bullet.rb'

class EnemyPlayer < Player
  Speed = 3
  MAX_ATTACK_SPEED = 3.0
  attr_reader :score
  attr_accessor :cooldown_wait, :attack_speed, :health, :armor, :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x, @y = x, y
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


  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
  end

  def update
    # @y += 3
    if is_alive
      if rand(2).even?
        @y += rand(5)
      else
        @y -= rand(5)
      end
      if rand(2).even?
        @x += rand(5)
      else
        @x -= rand(5)
      end

      @y = 0 if @y < 0
      @y = HEIGHT / 2 if @y > HEIGHT / 2

      @x = 0 if @x < 0
      @x = WIDTH if @x > WIDTH

      # puts "building is being deleted" if @y < HEIGHT
      # alive = @y < HEIGHT + @image.height

      # drops = []
      # if !alive 
      #   drops << MissilePack.new(@x, @y)
      # end

      # return {update: alive, drops: drops}
      @y < HEIGHT + @image.height
    else
      false
    end
  end
  
end