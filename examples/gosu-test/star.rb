# Also taken from the tutorial, but drawn with draw_rot and an increasing angle
# for extra rotation coolness!
class Star
  attr_reader :x, :y
  
  def initialize()
    @animation = Gosu::Image::load_tiles("media/star.png", 25, 25)
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    @x = rand * 800
    @y = 0
  end

  def draw  
    img = @animation[Gosu.milliseconds / 100 % @animation.size];
    img.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1, @color, :add)
  end
  
  def update
    # Move towards bottom of screen
    @y += 3
    # Return false when out of screen (gets deleted then)
    @y < 650
  end
end