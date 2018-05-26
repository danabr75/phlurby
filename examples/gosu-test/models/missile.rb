require_relative 'projectile.rb'
class Missile < Projectile
  attr_reader :x, :y, :time_alive, :mouse_start_x, :mouse_start_y
  COOLDOWN_DELAY = 30
  MAX_SPEED      = 25
  STARTING_SPEED = 0.0
  INITIAL_DELAY  = 2
  SPEED_INCREASE_FACTOR = 0.5
  DAMAGE = 50
  AOE = 0
  
  MAX_CURSOR_FOLLOW = 4

  # def hit_objects(object_groups)
  #   puts "HERE: #{self.class.get_damage}"
  #   super(object_groups)
  # end

  def get_image
    Gosu::Image.new("#{MEDIA_DIRECTORY}/missile.png")
  end

  def initialize(object, mouse_x = nil, mouse_y = nil, options = {})
    @image = get_image

    if LEFT == options[:side]
      @x = object.get_x - (object.get_width / 2)
      @y = object.get_y# - player.get_height
    elsif RIGHT == options[:side]
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
  
  def update mouse_x = nil, mouse_y = nil
    mouse_x = @mouse_start_x
    mouse_y = @mouse_start_y
    if @time_alive > self.get_initial_delay
      new_speed = self.get_starting_speed + (self.get_speed_increase_factor > 0 ? @time_alive * self.get_speed_increase_factor : 0)
      new_speed = self.class.get_max_speed if new_speed > self.class.get_max_speed
      @y -= new_speed
    end

    # Cursor is left of the missle, missile needs to go left. @x needs to get smaller. @x is greater than mouse_x
    if @x > mouse_x
      difference = @x - mouse_x
      if difference > self.get_max_cursor_follow
        difference = self.get_max_cursor_follow
      end
      @x = @x - difference
    else
      # Cursor is right of the missle, missile needs to go right. @x needs to get bigger. @x is smaller than mouse_x
      difference = mouse_x - @x
      if difference > self.get_max_cursor_follow
        difference = self.get_max_cursor_follow
      end
      @x = @x + difference
    end

    # Return false when out of screen (gets deleted then)
    @time_alive += 1

    @y > 0 && @y < HEIGHT && @x > 0 && @x < WIDTH
  end
end