class Cursor
  # attr_reader :img, :visible, :imgObj
  def initialize
    # image = Magick::Image::read("#{CURRENT_DIRECTORY}/media/crosshair.png").first#.resize(0.3)
    # @image = Gosu::Image.new(image, :tileable => true)
    @image = Gosu::Image.new("#{CURRENT_DIRECTORY}/media/crosshair.png")
  end


  def draw mouse_x, mouse_y
    # @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
    # @image.draw(mouse_x, mouse_y, ZOrder::Cursor)
    @image.draw(mouse_x - @image.width / 2, mouse_y - @image.height / 2, ZOrder::Cursor)
  end

end