class SmallExplosion
  attr_reader :x, :y, :time_to_live, :living_time

  def initialize(x = nil, y = nil)
    image = Magick::Image::read("media/smoke.png").first#.resize(0.3)

    @image = Gosu::Image.new(image, :tileable => true)
    @x = x
    @y = y
    @time_to_live = 50
    @living_time = 0

    # @color = Gosu::Color.new(0xff_000000)
    # @color.blue = 40

    puts "NEW SmallExplosion: #{@x} and #{@y}"
  end

  def draw
    # img = @image;
    # img.draw(@x, @y, ZOrder::Pickups)

    # img = @image[Gosu.milliseconds / 100 % @image.size];
    if @living_time > 0
      # fraction = (1.0).fdiv(@living_time.to_f)
      # 50 / 50
      # 49 / 50
      fraction = (@time_to_live - @living_time).to_f.fdiv(@time_to_live)
      if fraction < 1.0 && fraction > 0.05
        image = Magick::Image::read("media/smoke.png").first.resize(fraction)

        @image = Gosu::Image.new(image, :tileable => true)
      elsif fraction > 0.05
        @living_time = @time_to_live
      end
    end
    @image.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1)

  end


  def update
    if @living_time <= @time_to_live
      @living_time += 1
      @y += GLBackground::SCROLLING_SPEED - 1

      @y < HEIGHT + @image.height
    else
      # @y = HEIGHT + @image.height
      false
    end
  end


end