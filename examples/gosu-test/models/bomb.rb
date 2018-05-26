require 'ostruct'
require_relative 'projectile.rb'

class Bomb < Projectile
  COOLDOWN_DELAY = 50
  MAX_SPEED      = 5
  STARTING_SPEED = 3.0
  INITIAL_DELAY  = 0
  SPEED_INCREASE_FACTOR = 0.0
  DAMAGE = 100
  AOE = 150
  
  MAX_CURSOR_FOLLOW = 4

  def get_image
    Gosu::Image.new("#{MEDIA_DIRECTORY}/bomb.png")
  end

  def draw
    @image.draw(@x, @y, ZOrder::Projectiles, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
  end
  

  def update mouse_x = nil, mouse_y = nil
    vx = STARTING_SPEED * Math.cos(@angle * Math::PI / 180)

    vy =  STARTING_SPEED * Math.sin(@angle * Math::PI / 180)
    # Because our y is inverted
    vy = vy * -1

    @x = @x + vx
    @y = @y + vy

    super(mouse_x, mouse_y)
  end
end