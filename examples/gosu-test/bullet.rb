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
    drops = []
    objects.each do |object|
      if Gosu.distance(@x, @y, object.x, object.y) < 30
        # Missile destroyed
        @y = -100
        if object.respond_to?(:health) && object.respond_to?(:take_damage)
          object.take_damage(DAMAGE)
        end

        if object.respond_to?(:is_alive) && !object.is_alive && object.respond_to?(:drops)
          # puts "CALLING THE DROP"
          object.drops.each do |drop|
            drops << drop
          end
        end

      end
    end
    return drops
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