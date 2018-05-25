class SmallExplosion
  attr_reader :x, :y, :time_to_live, :living_time, :ship

  def initialize(x = nil, y = nil)
    @smoke = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/smoke.png", :tileable => true)
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/starfighterv4.png", :tileable => true)

    @x = x
    @y = y
    @time_to_live = 50
    @living_time = 0
  end

  def draw
    spin_down = 0
    if @living_time > 0
      spin_down = (@living_time * @living_time) / 5
    end
    if spin_down > (@living_time * 10)
      spin_down = @living_time * 10
    end
    @image.draw_rot(@x, @y, ZOrder::SmallExplosions, (360 - spin_down), 0.5, 0.5, 1, 1)

  end


  def update
    if @living_time <= @time_to_live
      @living_time += 1
      @y += GLBackground::SCROLLING_SPEED - 1

      # @y < HEIGHT + @image.height
      @y < HEIGHT + @image.height
    else
      # @y = HEIGHT + @image.height
      false
    end
  end


end