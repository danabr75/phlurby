class MissilePack
  attr_reader :x, :y

  def initialize(x = nil, y = nil)
    # image = Magick::Image::read("#{CURRENT_DIRECTORY}/media/missile_pack.png").first.resize(0.3)

    # @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/grappling_hook.png")
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/missile_pack.png", :tileable => true)
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

  def collected_by_player player
    puts "1 BEFORE player: #{player.inspect}"
    puts "2 BEFORE player: #{player.rockets}"
    player.rockets += 25
    puts "3 AFTER player: #{player.inspect}"
    puts "4 AFTER player: #{player.rockets}"
  end


end