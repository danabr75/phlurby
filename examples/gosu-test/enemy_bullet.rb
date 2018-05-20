require_relative 'bullet.rb'
class EnemyBullet < Bullet
  attr_reader :x, :y
  COOLDOWN_DELAY = 30
  
  def initialize(animation, player)
    @animation = animation
    # @color = Gosu::Color.new(0xff_000000)
    # @color.red = rand(255 - 40) + 40
    # @color.green = rand(255 - 40) + 40
    # @color.blue = rand(255 - 40) + 40
    @x = player.get_x
    @y = player.get_y# - player.get_height
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
    @y += 6

    # Return false when out of screen (gets deleted then)
    @y < HEIGHT
  end

  def hit_player(player)
    if Gosu.distance(@x, @y, player.x, player.y) < 30
      @y = HEIGHT
      player.health -= 5
      true
    else
      false
    end
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