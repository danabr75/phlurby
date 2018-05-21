class Missile
  attr_reader :x, :y, :time_alive
  COOLDOWN_DELAY = 30
  MAX_SPEED      = 25
  STARTING_SPEED = 1.2
  DAMAGE = 50
  
  def initialize(object, side)
    @animation = Gosu::Image.new("media/missile.png")
    # @color = Gosu::Color.new(0xff_000000)
    # @color.red = rand(255 - 40) + 40
    # @color.green = rand(255 - 40) + 40
    # @color.blue = rand(255 - 40) + 40
    if side == 'left'
      @x = object.get_x - (object.get_width / 2)
      @y = object.get_y# - player.get_height
    elsif side == 'right'
      @x = (object.get_x + object.get_width / 2) - 4
      @y = object.get_y# - player.get_height
    else
      @x = object.get_x
      @y = object.get_y
    end
    @time_alive = 0
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
  
  def update
    new_speed = STARTING_SPEED * @time_alive
    new_speed = MAX_SPEED if new_speed > MAX_SPEED
    @y -= new_speed

    # Return false when out of screen (gets deleted then)
    @time_alive += 1

    @y > 0
  end


  def hit_objects(objects)
    objects.reject! do |object|
      if Gosu.distance(@x, @y, object.x, object.y) < 30
        @y = 0
        true
      else
        false
      end
    end
  end


  def hit_object(object)
    return_value = nil
    if Gosu.distance(@x, @y, object.x, object.y) < 30
      @y = 0
      return_value = DAMAGE
    else
      return_value = 0
    end
    return return_value
  end


end