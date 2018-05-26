require_relative 'general_object.rb'

class HealthPack < GeneralObject
  attr_reader :x, :y

  HEALTH_BOOST = 25

  def initialize(x = nil, y = nil)
    @image = Gosu::Image.new("#{MEDIA_DIRECTORY}/health_pack_0.png", :tileable => true)
    @x = x
    @y = y
  end

  def draw
    # img = @image;
    # img.draw(@x, @y, ZOrder::Pickups)

    # img = @image[Gosu.milliseconds / 100 % @image.size];


    image_rot = (Gosu.milliseconds / 50 % 26)
    # 13 is the middle
    # puts "image_rot: #{image_rot}"
    if image_rot >= 13
      # When we get to 13, we need to go to 11
      # When we get to 14, we need to go to 10
      # When we get to 15, we need to go to 9
      image_rot = 26 - image_rot
    # puts "new_image_rot: #{image_rot}"
    end 
    image_rot = 12 if image_rot == 13
    @image = Gosu::Image.new("#{MEDIA_DIRECTORY}/health_pack_#{image_rot}.png", :tileable => true)

    # @image.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1)
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::Pickups)
  end


  def update mouse_x = nil, mouse_y = nil
    @y += GLBackground::SCROLLING_SPEED 

    @y < HEIGHT + @image.height

    # img = @animation[Gosu.milliseconds / 100 % @animation.size];
    # img.draw_rot(@x, @y, ZOrder::Pickups, @y, 0.5, 0.5, 1, 1, @color, :add)
  end

  def collected_by_player player
    if player.health + HEALTH_BOOST > player.class::MAX_HEALTH 
      player.health = player.class::MAX_HEALTH
    else
      player.health += HEALTH_BOOST
    end
  end


end