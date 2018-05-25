require_relative 'missile.rb'

class Bomb < Missile
  attr_reader :x, :y, :time_alive, :mouse_start_x, :mouse_start_y, :vector_x, :vector_y
  # COOLDOWN_DELAY = 250
  COOLDOWN_DELAY = 50
  MAX_SPEED      = 5
  STARTING_SPEED = 3.0
  INITIAL_DELAY  = 0
  SPEED_INCREASE_FACTOR = 0.0
  DAMAGE = 100
  AOE = 150
  
  MAX_CURSOR_FOLLOW = 4

  def get_image
    Gosu::Image.new("#{CURRENT_DIRECTORY}/media/bomb.png")
  end

  def initialize(object, mouse_x = nil, mouse_y = nil, side = nil)
    @image = get_image
    @time_alive = 0
    @mouse_start_x = mouse_x
    @mouse_start_y = mouse_y
    # object.x
    # object.y
    @vector_x = object.x - mouse_x
    @vector_y = object.y - mouse_y
    @x = object.x
    @y = object.y
  end

  def draw
    # img = @animation;
    # img.draw(@x, @y, ZOrder::Bullets, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
    @image.draw_rot(@x, @y, ZOrder::Bullets, @y, 0.5, 0.5, 1, 1)
  end
  
  def update mouse_x = nil, mouse_y = nil
    mouse_x = @mouse_start_x
    mouse_y = @mouse_start_y
    # if @time_alive > INITIAL_DELAY
    #   new_speed = STARTING_SPEED + (SPEED_INCREASE_FACTOR > 0 ? @time_alive * SPEED_INCREASE_FACTOR : 0)
    #   new_speed = MAX_SPEED if new_speed > MAX_SPEED
    #   @y -= new_speed
    # end

    difference_x = [(@x + @vector_x).abs, MAX_SPEED].max
    difference_y = [(@y + @vector_y).abs, MAX_SPEED].max

    if (@x + @vector_x) > 0
      @x = @x - difference_x
    else
      @x = @x + difference_x
    end

    if (@y + @vector_y) > 0
      @y = @y - difference_y
    else
      @y = @y + difference_y
    end


    # Cursor is left of the missle, missile needs to go left. @x needs to get smaller. @x is greater than mouse_x
    # if @x > mouse_x
    #   difference = @x - mouse_x
    #   if difference > MAX_CURSOR_FOLLOW
    #     difference = MAX_CURSOR_FOLLOW
    #   end
    #   @x = @x - difference
    # else
    #   # Cursor is right of the missle, missile needs to go right. @x needs to get bigger. @x is smaller than mouse_x
    #   difference = mouse_x - @x
    #   if difference > MAX_CURSOR_FOLLOW
    #     difference = MAX_CURSOR_FOLLOW
    #   end
    #   @x = @x + difference
    # end

    # Return false when out of screen (gets deleted then)
    @time_alive += 1

    @y > 0
  end

  def hit_objects(objects)
    drops = []
    points = 0
    exploded = false
    objects.each do |object|
      next if exploded
      if Gosu.distance(@x, @y, object.x, object.y) < 35
        exploded = true
      end
    end

    if exploded
      objects.each do |object|
        if Gosu.distance(@x, @y, object.x, object.y) < AOE
          # Missile destroyed
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
      @y = -100
    end

    return {drops: drops, point_value: points}
  end




end