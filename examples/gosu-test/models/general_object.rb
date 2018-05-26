class GeneralObject
  attr_accessor :time_alive, :x, :y
  LEFT  = 'left'
  RIGHT = 'right'
  SCROLLING_SPEED = 4

  def get_image
    Gosu::Image.new("#{MEDIA_DIRECTORY}/question.png")
  end

  def initialize(x = nil, y = nil)
    @image = get_image
    @x = x
    @y = y
    @time_alive = 0
  end

  def get_height
    @image.height
  end

  def get_width
    @image.width
  end

  def get_size
    (@image.height * @image.width) / 2
  end

  def get_radius
    ((@image.height + @image.width) / 2) / 2
  end  

  def update mouse_x = nil, mouse_y = nil
    # Inherit, add logic, then call this to calculate whether it's still visible.
    @time_alive ||= 0 # Temp solution
    @time_alive += 0
    return is_on_screen?
  end

  protected

  def is_on_screen?
    # @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
    @y > (0 - get_height) && @y < (HEIGHT + get_height) && @x > (0 - get_width) && @x < (WIDTH + get_width)
  end
end