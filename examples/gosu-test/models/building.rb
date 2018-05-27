require_relative 'general_object.rb'

class Building < GeneralObject
  POINT_VALUE_BASE = 1
  attr_accessor :health, :armor, :x, :y

  def initialize(x = nil, y = nil)
    # image = Magick::Image::read("#{MEDIA_DIRECTORY}/building.png").first.resize(0.3)
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = Gosu::Image.new("#{MEDIA_DIRECTORY}/building.png")
    @x = rand * 800
    @y = 0 - @image.height
    # puts "NEW BUILDING: #{@x} and #{@y}"
    @health = 15
    @armor = 0
  end

  def get_points
    return POINT_VALUE_BASE
  end

  def is_alive
    @health > 0
  end

  def get_height
    @image.height
  end

  def get_width
    @image.width
  end

  def take_damage damage
    @health -= damage
  end

  def drops
    rand_num = rand(10)
    if rand(10) == 9
      [HealthPack.new(@x, @y)]
    elsif rand(10) == 8
      [BombPack.new(@x, @y)]
    else
      [MissilePack.new(@x, @y)]
    end
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Building)
  end

  def update width, height, mouse_x = nil, mouse_y = nil, player = nil
    # @y += 3
    if is_alive
      @y += GLBackground::SCROLLING_SPEED

      # puts "building is being deleted" if @y < HEIGHT
      # alive = @y < HEIGHT + @image.height

      # drops = []
      # if !alive 
      #   drops << MissilePack.new(@x, @y)
      # end

      # return {update: alive, drops: drops}
      @y < height + @image.height
    else
      false
    end
  end
end