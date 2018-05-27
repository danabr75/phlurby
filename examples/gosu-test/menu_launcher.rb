require 'gosu'

CURRENT_DIRECTORY = File.expand_path('../', __FILE__)
MEDIA_DIRECTORY   = File.expand_path('../', __FILE__) + "/media"

Dir["#{CURRENT_DIRECTORY}/lib/*.rb"].each { |f| require f }
Dir["#{CURRENT_DIRECTORY}/models/*.rb"].each { |f| require f }

require "#{CURRENT_DIRECTORY}/game_window.rb"

# @menu = Menu.new(self) #instantiate the menu, passing the Window in the constructor

# @menu.add_item(Gosu::Image.new("#{MEDIA_DIRECTORY}question.png"), 100, 200, 1, lambda { self.close }, Gosu::Image.new(self, "#{MEDIA_DIRECTORY}question.png", false))
# @menu.add_item(Gosu::Image.new("#{MEDIA_DIRECTORY}question.png"), 100, 250, 1, lambda { puts "something" }, Gosu::Image.new(self, "#{MEDIA_DIRECTORY}question.png", false))


class Main < Gosu::Window
  def initialize
    super(640, 480, false)
    @cursor = Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/cursor.png", false)
    @gl_background = GLBackground.new
    # x = self.width / 2 - 100
    # y = self.height  / 2 - 100
    @ui_y = 0
    @ui_x = 0
    reset_font_ui_y
    lineHeight = 50
    self.caption = "A menu with Gosu"
    # items = Array["exit", "additem", "item"]
    # actions = Array[lambda { self.close }, lambda {
    #   @menu.add_item(Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/item.png", false), x, y, 1, lambda { })
    #   y += lineHeight
    # }, lambda {}]
    @menu = Menu.new(self)
    # for i in (0..items.size - 1)
    #   @menu.add_item(Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/#{items[i]}.png", false), x, y, 1, actions[i], Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/#{items[i]}_hover.png", false))
    #   y += lineHeight
    # end
    @menu.add_item(Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/exit.png", false), get_font_ui_x, get_font_ui_y, 1, lambda { self.close }, Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/exit_hover.png", false))
    @menu.add_item(Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/start.png", false), get_font_ui_x, get_font_ui_y, 1, lambda { self.close; GameWindow.start(nil, nil, {block_controls_until_button_up: true}) }, Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/question.png", false))
    # @back = Gosu::Image.new(self, "#{MEDIA_DIRECTORY}/back.png", false)
  end

  def update
    @menu.update
    @gl_background.scroll
  end

  def draw
    @cursor.draw(self.mouse_x, self.mouse_y, 2)
    # @back.draw(0,0,0)
    @menu.draw
    @gl_background.draw(ZOrder::Background)
  end

  def button_down id
    if id == Gosu::MsLeft then
      @menu.clicked
    end
  end

  def get_font_ui_y
    return_value = @ui_y
    @ui_y += 50 
    return return_value
  end

  def get_font_ui_x
    return @ui_x
  end

  def reset_font_ui_y
    @ui_y = self.height  / 2 - 100
    @ui_x = self.width / 2 - 100
  end
end

Main.new.show
