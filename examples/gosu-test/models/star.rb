# Also taken from the tutorial, but drawn with draw_rot and an increasing angle
# for extra rotation coolness!
require_relative 'pickup.rb'

class Star < Pickup
  POINT_VALUE_BASE = 2
  
  def get_image
    Gosu::Image::load_tiles("#{MEDIA_DIRECTORY}/star.png", 25, 25)
  end

  def initialize(x = nil, y = nil)
    @image = get_image
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    @x = x || rand * 800
    @y = y || 0
  end


  def get_points
    return POINT_VALUE_BASE
  end

  def get_height
    25
  end

  def get_width
    25
  end

  def get_size
    25
  end


  def draw 
    img = @image[Gosu.milliseconds / 100 % @image.size];
    img.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1, @color, :add)
  end
  
  # def update mouse_x = nil, mouse_y = nil
  #   # Move towards bottom of screen
  #   @y += 1
  #   super(mouse_x, mouse_y)
  # end

  def collected_by_player player
    player.attack_speed += 0.1
    player.attack_speed = Player::MAX_ATTACK_SPEED if player.attack_speed > Player::MAX_ATTACK_SPEED
  end
end