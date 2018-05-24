require_relative 'bullet.rb'
require_relative 'missile.rb'
require_relative 'missile_pack.rb'
require_relative 'health_pack.rb'

class Building
  POINT_VALUE_BASE = 1
  attr_accessor :health, :armor, :x, :y

  def initialize(x = nil, y = nil)
    # image = Magick::Image::read("#{CURRENT_DIRECTORY}/media/building.png").first.resize(0.3)
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/building.png")
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
    if rand(5) == 4
      [HealthPack.new(@x, @y)]
    else
      [MissilePack.new(@x, @y)]
    end
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Building)
  end

  def update
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
      @y < HEIGHT + @image.height
    else
      false
    end
  end
end