class MissilePack
  attr_reader :x, :y

  def initialize(x = nil, y = nil)
    image = Magick::Image::read("media/missile_pack.png").first.resize(0.3)

    @image = Gosu::Image.new(image, :tileable => true)
    @x = x
    @y = y

    # @color = Gosu::Color.new(0xff_000000)
    # @color.blue = 40

    puts "NEW MissilePack: #{@x} and #{@y}"
  end

  def draw
    # img = @image;
    # img.draw(@x, @y, ZOrder::Pickups)

    # img = @image[Gosu.milliseconds / 100 % @image.size];
    @image.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1)

  end


  def update
    @y += GLBackground::SCROLLING_SPEED 

    @y < HEIGHT + @image.height
  end

end