class Missile
  attr_reader :x, :y, :time_alive, :mouse_start_x, :mouse_start_y
  COOLDOWN_DELAY = 30
  MAX_SPEED      = 25
  STARTING_SPEED = 0.0
  INITIAL_DELAY  = 2
  SPEED_INCREASE_FACTOR = 0.5
  DAMAGE = 50
  
  MAX_CURSOR_FOLLOW = 4

  def initialize(object, mouse_x = nil, mouse_y = nil, side = nil)

    # animation = Magick::Image::read("media/missile.png").first.resize(0.3)
    # @animation = Gosu::Image.new(animation, :tileable => true)
    @animation = Gosu::Image.new("media/missile.png")

    # @animation = Gosu::Image.new("media/missile.png")
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
    @mouse_start_x = mouse_x
    @mouse_start_y = mouse_y
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
  
  def update mouse_x = nil, mouse_y = nil
    mouse_x = @mouse_start_x
    mouse_y = @mouse_start_y
    if @time_alive > INITIAL_DELAY
      new_speed = STARTING_SPEED + (@time_alive * SPEED_INCREASE_FACTOR)
      new_speed = MAX_SPEED if new_speed > MAX_SPEED
      @y -= new_speed
    end

    # Cursor is left of the missle, missile needs to go left. @x needs to get smaller. @x is greater than mouse_x
    if @x > mouse_x
      difference = @x - mouse_x
      if difference > MAX_CURSOR_FOLLOW
        difference = MAX_CURSOR_FOLLOW
      end
      @x = @x - difference
    else
      # Cursor is right of the missle, missile needs to go right. @x needs to get bigger. @x is smaller than mouse_x
      difference = mouse_x - @x
      if difference > MAX_CURSOR_FOLLOW
        difference = MAX_CURSOR_FOLLOW
      end
      @x = @x + difference
    end

    # Return false when out of screen (gets deleted then)
    @time_alive += 1

    @y > 0
  end


  def hit_objects(objects)
    drops = []
    points = 0
    objects.each do |object|
      if Gosu.distance(@x, @y, object.x, object.y) < 30
        # Missile destroyed
        @y = -100
        if object.respond_to?(:health) && object.respond_to?(:take_damage)
          object.take_damage(DAMAGE)
        end

        if object.respond_to?(:is_alive) && !object.is_alive && object.respond_to?(:drops)
          puts "CALLING THE DROP"
          object.drops.each do |drop|
            drops << drop
          end
        end

        if object.respond_to?(:is_alive) && !object.is_alive && object.respond_to?(:get_points)
          points = points + object.get_points
        end

      end
    end
    return {drops: drops, point_value: points}
  end


  def hit_object(object)
    return_value = nil
    if Gosu.distance(@x, @y, object.x, object.y) < 30
      @y = -50
      return_value = DAMAGE
    else
      return_value = 0
    end
    return return_value
  end


end