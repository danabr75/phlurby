require_relative 'bullet.rb'
require_relative 'missile.rb'
require_relative 'missile_pack.rb'

class Building
  attr_accessor :health, :armor, :x, :y

  def initialize(x = nil, y = nil)
    # @image = Gosu::Image.new("media/spaceship.png", :tileable => true)
    # Magick::Image.new(2 * RADIUS, 2 * RADIUS) { self.background_color = 'none' }
    # image = Magick::Image::read("media/spaceship.png").first.resize(0.5)
    # image = Magick::Image::read("media/starfighter.bmp").first
    image = Magick::Image::read("media/building.png").first.resize(0.3)

    # img = Magick::Image.new(columns. rows) {self.background_color = Magick::Pixel.new(rr, gg, bb, Magick::MaxRGB/2)}
    # puts "image:"
    # puts image.inspect
    # puts image.background_color
    # image.write("media/spaceship-result.png") do
    #   self.background_color = 'purple'
    # end

    @image = Gosu::Image.new(image, :tileable => true)
    @x = rand * 800
    @y = 0 - @image.height
    # puts "NEW BUILDING: #{@x} and #{@y}"
    @health = 15
    @armor = 0
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
    [MissilePack.new(@x, @y)]
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