require_relative 'missile.rb'
require 'ostruct'

class Bomb < Missile
  attr_reader :x, :y, :time_alive, :mouse_start_x, :mouse_start_y, :vector_x, :vector_y, :angle, :radian
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

  def angle(point1, point2)
    # puts "POINT1: #{point1}"
    # puts "POINT2: #{point2}"
    # return 90 if vertical?(point1, point2)
    # return 0 if horizontal?(point1, point2)
    # point1, point2 = [point1, point2].sort_by(&:x)
    # delta_x = point1.x - point2.x
    # delta_y = point1.y - point2.y

    # brng = point1.bearing_to(point2)
    # puts "BRNG: #{brng}"

    # dist = point1.distance_to(point2) # in km
    # puts "DIST: #{dist}"

    # bearing = 90 - (180/pi)*atan2(y2-y1, x2-x1)
    # bearing = 90 - (180/Math::PI)*Math.atan2(point2.y-point1.y, point2.x-point1.x)
    bearing = (180/Math::PI)*Math.atan2(point1.y-point2.y, point2.x-point1.x)
    # bearing = (180/Math::PI)*Math.atan2(point2.x-point1.x, point1.y-point2.y)

    return bearing
    # if point1.y > point2.y # inverted axis/origin
    #   # Math.atan(delta_y / delta_x)
    # #   Geometry.to_degrees(Math.atan(delta_y / delta_x)).abs
    #   degrees = Math.atan(delta_y / delta_x) * 180 / Math::PI
    # else
    # #   # Add 90 degrees when angle is in 3rd quadrant
    #   # Math.atan(delta_x / delta_y)
    #   degrees = Math.atan(delta_x / delta_y) * 180 / Math::PI
    #   degrees.abs + 90
    # #   Geometry.to_degrees(Math.atan(delta_x / delta_y)).abs + 90
    # end
  end

  def radian(point1, point2)
    puts "POINT1: #{point1}"
    puts "POINT2: #{point2}"
    # return 90 if vertical?(point1, point2)
    # return 0 if horizontal?(point1, point2)
    # point1, point2 = [point1, point2].sort_by(&:x)
    # delta_x = point1.x - point2.x
    # delta_y = point1.y - point2.y

    # brng = point1.bearing_to(point2)
    # puts "BRNG: #{brng}"

    # dist = point1.distance_to(point2) # in km
    # puts "DIST: #{dist}"

    # bearing = 90 - (180/pi)*atan2(y2-y1, x2-x1)
    # bearing = 90 - (180/Math::PI)*Math.atan2(point2.y-point1.y, point2.x-point1.x)
    rdn = Math.atan2(point1.y-point2.y, point2.x-point1.x)
    # rdn = Math.atan2(point2.x-point1.x, point1.y-point2.y)

    return rdn
    # if point1.y > point2.y # inverted axis/origin
    #   # Math.atan(delta_y / delta_x)
    # #   Geometry.to_degrees(Math.atan(delta_y / delta_x)).abs
    #   degrees = Math.atan(delta_y / delta_x) * 180 / Math::PI
    # else
    # #   # Add 90 degrees when angle is in 3rd quadrant
    #   # Math.atan(delta_x / delta_y)
    #   degrees = Math.atan(delta_x / delta_y) * 180 / Math::PI
    #   degrees.abs + 90
    # #   Geometry.to_degrees(Math.atan(delta_x / delta_y)).abs + 90
    # end
  end

  def initialize(object, mouse_x = nil, mouse_y = nil, side = nil)
    @image = get_image
    @time_alive = 0
    @mouse_start_x = mouse_x
    @mouse_start_y = mouse_y
    # object.x
    # object.y
    # @vector_x = object.x / mouse_x
    # @vector_y = object.y / mouse_y
    @x = object.x
    @y = object.y

    start_point =   OpenStruct.new(:x => @x - WIDTH / 2, :y => @y - HEIGHT / 2)
    # start_point = GeoPoint.new(@x - WIDTH / 2, @y - HEIGHT / 2)
    # end_point   =   OpenStruct.new(:x => @mouse_start_x, :y => @mouse_start_y)
    end_point   =   OpenStruct.new(:x => @mouse_start_x - WIDTH / 2, :y => @mouse_start_y - HEIGHT / 2)
    # end_point = GeoPoint.new(@mouse_start_x - WIDTH / 2, @mouse_start_y - HEIGHT / 2)
    @angle = angle(start_point, end_point)
    @radian = radian(start_point, end_point)


    if @angle < 0
      @angle = 360 - @angle.abs
    end

    puts "ANGLE: #{@angle}"
    puts "RADIAN: #{@radian}"



    # puts "A - X and Y: #{@x} - #{@y}"
    # puts "B - X and Y: #{@mouse_start_x} - #{@mouse_start_y}"
    # # dot = @x * @mouse_start_x + @y * @mouse_start_y      # dot product between [x1, y1] and [x2, y2]
    # # det = @x * @mouse_start_y - @y * @mouse_start_x      # determinant
    # # @angle = Math.atan2(det, dot)  # atan2(y, x) or atan2(sin, cos)
    # # @angle = Math.atan2(det, dot)  # atan2(y, x) or atan2(sin, cos)
    # # @angle = Math.sqrt(@x ** 2 + @y ** 2 )

    # puts "old x and y: #{@x} and #{@y}"
    # cartesian_x_start = @x - WIDTH / 2
    # cartesian_y_start = @y - HEIGHT / 2
    # puts "new x and y: #{cartesian_x_start} and #{cartesian_y_start}"

    # cartisian_x_end = mouse_x - WIDTH / 2
    # cartisian_y_end = mouse_y - HEIGHT / 2


    # # dot = cartesian_x_start * cartisian_x_end + cartesian_y_start * cartisian_y_end      # dot product between [x1, y1] and [x2, y2]
    # # det = cartesian_x_start * cartisian_y_end - cartesian_y_start * cartisian_x_end      # determinant
    # # @angle = Math.atan2(det, dot)  # atan2(y, x) or atan2(sin, cos)

    # @angle = Math.atan2(cartisian_y_end - cartesian_y_start, cartisian_x_end - cartesian_x_start)

    # # x = r * cos( θ )
    # # y = r * sin( θ )

    # # @angle = Math.tan(y/x) ** -1
    # # puts "y/x: #{y.fdiv(x)}"
    # # @angle = Math.atan(y.fdiv(x))# ** -1
  end

  def draw
    # img = @animation;
    # img.draw(@x, @y, ZOrder::Bullets, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
    @image.draw_rot(@x, @y, ZOrder::Bullets, @y, 0.5, 0.5, 1, 1)
  end
  

  def euclidean_distance(vector1, vector2)
    sum = 0
    vector1.zip(vector2).each do |v1, v2|
      component = (v1 - v2)**2
      sum += component
    end
    Math.sqrt(sum)
  end


def x_after_moving(distance, angle)
  puts "x_after_moving: #{angle}"
  distance * Math.sin(angle * Math::PI / 180)
end
def y_after_moving(distance, angle)
  distance * Math.cos(angle * Math::PI / 180).round
end


  def update mouse_x = nil, mouse_y = nil
    # puts "update angle: #{@angle}"
    # x = Math.cos(@radian);
    # y = Math.sin(@radian);
    # @x = x_after_moving(2, @angle)
    # @y = y_after_moving(2, @angle)

    # vx = 2 * Math.cos(@angle)
    # vy = 2 * Math.sin(@angle)

    vx = STARTING_SPEED * Math.cos(@angle * Math::PI / 180)

    vy =  STARTING_SPEED * Math.sin(@angle * Math::PI / 180)
    # Because our y is inverted
    vy = vy * -1

    # The 'd' is the distance, the 'a' is the angle.

    @x = @x + vx
    @y = @y + vy

    # cos_angle = Math.cos(@angle)
    # sin_angle = Math.sin(@angle)
    # sinAngle = Math.sin(this.anims.idle.angle);
    # cosAngle = Math.cos(this.anims.idle.angle);
    # bulletX = (this.pos.x + this.halfWidth) + (47 * sinAngle);
    # bulletY = (this.pos.y + 47) - (47 * cosAngle);
    # if @angle > 0
    #   @x = (@x) + (2 * sin_angle)
    # else
    #   @x = (@x) - (2 * sin_angle)
    # end
    # if @angle.abs > 100
    #   @y = (@y) + (2 * cos_angle)
    # else
    #   @y = (@y) - (2 * cos_angle)
    # end
    # # @y += -GLBackground::SCROLLING_SPEED / 2

    # puts "X AND Y: #{@x} and #{@y}"
    # distance = euclidean_distance([(WIDTH  / 2), (HEIGHT / 2)], [@x, @y])
    # @x = mouse_x
    # @y = mouse_y
    # @x = @x + @x * @angle
    # @y = @y + @y * @angle

    # puts "OLD: #{@x} and #{@y}"
    # @x = (WIDTH  / 2) + Math.cos( @angle ) * distance; 
    # @y = (HEIGHT / 2) + Math.sin( @angle ) * distance; 

    # angle = atan2( y - cy, x - cx ); 
    # distance = dist( cx, cy, x, y ); 

    # @x = (WIDTH  / 2)# + Math.cos( @angle ) * STARTING_SPEED
    # @y = (HEIGHT / 2)# + Math.sin( @angle ) * STARTING_SPEED
    # @y = @y + 1
    # @x = @x + 1
    # puts "NEW: #{@x} and #{@y}"
    # if @time_alive > INITIAL_DELAY
    #   new_speed = STARTING_SPEED + (SPEED_INCREASE_FACTOR > 0 ? @time_alive * SPEED_INCREASE_FACTOR : 0)
    #   new_speed = MAX_SPEED if new_speed > MAX_SPEED
    #   @y -= new_speed
    # end

    # difference_x = [(@x + @vector_x).abs, MAX_SPEED].max
    # difference_y = [(@y + @vector_y).abs, MAX_SPEED].max

    # vel += accel * dt;

    # @x = @x * @time_alive; 
    # @y = @y * @time_alive; 

    # @x = @x * @vector_x
    # @y = @y * @vector_y

    # if (@x + @vector_x) > 0
    #   @x = @x - difference_x
    # else
    #   @x = @x + difference_x
    # end

    # if (@y + @vector_y) > 0
    #   @y = @y - difference_y
    # else
    #   @y = @y + difference_y
    # end


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

    @y > 0 && @y < HEIGHT && @x > 0 && @x < WIDTH
  end


  # Need to pass all objects at the same time, buildings AND enemies
  def hit_objects(objects)
    drops = []
    points = 0
    exploded = false
    objects.each do |object|
      break if exploded
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