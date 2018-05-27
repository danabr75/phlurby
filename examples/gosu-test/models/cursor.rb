require_relative 'general_object.rb'
class Cursor < GeneralObject
  # attr_reader :img, :visible, :imgObj


  def get_image
    Gosu::Image.new("#{MEDIA_DIRECTORY}/crosshair.png")
  end

  
  def initialize
    # image = Magick::Image::read("#{MEDIA_DIRECTORY}/crosshair.png").first#.resize(0.3)
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = get_image
  end


  def draw scale, mouse_x, mouse_y
    # @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
    # @image.draw(mouse_x, mouse_y, ZOrder::Cursor)
    @image.draw(mouse_x - @image.width / 2, mouse_y - @image.height / 2, ZOrder::Cursor, scale, scale)
  end

end