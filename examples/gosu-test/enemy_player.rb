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
    @health = 100
    @armor = 0
  end

  def attack
    return [
      EnemyBullet.new(self)
    ]
  end
  
  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
  end
  
end