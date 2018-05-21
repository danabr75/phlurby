class Cursor
  # attr_reader :img, :visible, :imgObj
  def initialize
    # @img=img
    # @visible=visible
    # @imgObj=Gosu::Image.new(window,img,true)
    # @forced=false
    image = Magick::Image::read("media/crosshair.png").first#.resize(0.3)
    @image = Gosu::Image.new(image, :tileable => true)
  end


  def draw mouse_x, mouse_y
    # @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Player)
    # @image.draw(mouse_x, mouse_y, ZOrder::Cursor)
    @image.draw(mouse_x - @image.width / 2, mouse_y - @image.height / 2, ZOrder::Cursor)
  end

end