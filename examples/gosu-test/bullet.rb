class Bullet
  attr_reader :x, :y
  DAMAGE = 5
  COOLDOWN_DELAY = 30
  
  def initialize(player, side = nil)
    @animation = Gosu::Image.new("media/bullet-mini.png")
    # @color = Gosu::Color.new(0xff_000000)
    # @color.red = rand(255 - 40) + 40
    # @color.green = rand(255 - 40) + 40
    # @color.blue = rand(255 - 40) + 40
    if side == 'left'
      @x = player.get_x - (player.get_width / 2)
      @y = player.get_y# - player.get_height
    else
      @x = (player.get_x + player.get_width / 2) - 4
      @y = player.get_y# - player.get_height
    end
  end

  def draw
    # puts Gosu.milliseconds
    # puts @animation.size
    # puts 100 % @animation.size
    # puts "Gosu.milliseconds / 100 % @animation.size: #{Gosu.milliseconds / 100 % @animation.size}"
    img = @animation;
    # img.draw(@x, @y, ZOrder::Bullets, :add)
    img.draw(@x, @y, ZOrder::Bullets, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
    # img.draw_rect(@x, @y, 25, 25, @x + 25, @y + 25, :add)
  end
  
  def update mouse_x, mouse_y
    @y -= 6

    # Return false when out of screen (gets deleted then)
    @y > 0
  end


  def hit_objects(objects)
    objects.reject! do |object|
      if Gosu.distance(@x, @y, object.x, object.y) < 30
        # puts "HIT STAR!!"
        @y = -50
        # @score += 10
        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end


  def hit_object(object)
    return_value = nil
    if Gosu.distance(@x, @y, object.x, object.y) < 30
      # puts "1"
      @y = 0
      return_value = DAMAGE
    else
      # puts "2"
      return_value = 0
    end
    # puts "rEUTRINING: #{return_value}"
    return return_value
  end


end