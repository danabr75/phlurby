require_relative 'bullet.rb'
class EnemyBullet < Bullet
  COOLDOWN_DELAY = 30
  
  def initialize(player)
    @animation = Gosu::Image.new("media/bullet-mini-reverse.png")
    @x = player.get_x
    @y = player.get_y# - player.get_height
  end

  def draw
    # puts Gosu.milliseconds
    # puts @animation.size
    # puts 100 % @animation.size
    # puts "Gosu.milliseconds / 100 % @animation.size: #{Gosu.milliseconds / 100 % @animation.size}"
    img = @animation;
    # img.draw(@x, @y, ZOrder::Bullets, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
    img.draw_rot(@x, @y, ZOrder::Bullets, 180)
  end
  
  def update mouse_x = nil, mouse_y = nil
    @y += 6

    # Return false when out of screen (gets deleted then)
    @y < HEIGHT
  end

  # def hit_player(player)
  #   if Gosu.distance(@x, @y, player.x, player.y) < 30
  #     @y = HEIGHT
  #     player.health -= 5
  #     true
  #   else
  #     false
  #   end
  # end


  def hit_object(object)
    return_value = nil
    if Gosu.distance(@x, @y, object.x, object.y) < 30
      # puts "1"
      @y = HEIGHT
      return_value = DAMAGE
    else
      # puts "2"
      return_value = 0
    end
    # puts "rEUTRINING: #{return_value}"
    return return_value
  end

  
  # def hit_stars(stars)
  #   stars.reject! do |star|
  #     if Gosu.distance(@x, @y, star.x, star.y) < 35
  #       # puts "HIT STAR!!"
  #       @y = 0
  #       # @score += 10
  #       # stop that!
  #       # @beep.play
  #       true
  #     else
  #       false
  #     end
  #   end
  # end

end