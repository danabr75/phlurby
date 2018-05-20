class Missile
  attr_reader :x, :y
  COOLDOWN_DELAY = 30
  
  def initialize(animation, player, side)
    @animation = animation
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
  
  def update
    @y -= 6

    # Return false when out of screen (gets deleted then)
    @y > 0
  end

  
  def hit_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        # puts "HIT STAR!!"
        @y = 0
        # @score += 10
        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end
  
  def hit_enemies(enemies)
    enemies.reject! do |enemy|
      if Gosu.distance(@x, @y, enemy.x, enemy.y) < 30
        # puts "HIT STAR!!"
        # @y = 0
        # @score += 10
        # stop that!
        # @beep.play
        true
      else
        false
      end
    end
  end


end