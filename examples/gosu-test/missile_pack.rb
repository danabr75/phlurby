class MissilePack
  attr_reader :x, :y

  def initialize(x = nil, y = nil)
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/missile_pack.png", :tileable => true)
    @x = x
    @y = y
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1)

  end


  def update
    @y += GLBackground::SCROLLING_SPEED 

    @y < HEIGHT + @image.height
  end

  def collected_by_player player
    player.rockets += 25
  end


end