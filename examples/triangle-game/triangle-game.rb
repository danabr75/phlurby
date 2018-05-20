# A simple "Triangle Game" that allows you to move a Roguelike '@' around the
# window (and off of it). This is a working example on MacOS 10.12 as of Dec 16, 2017.
# This combines some of the Ruby2D tutorial code with keypress management
# that actually works.
# 
# Keys: hjkl: movement, q: quit
# 
# To run: ruby triangle-game.rb after installing the Simple2D library and Ruby2D Gem.
#
# Author: Douglas P. Fields, Jr.
# E-mail: symbolics@lisp.engineer
# Site: https://symbolics.lisp.engineer/
# Copyright 2017 Douglas P. Fields, Jr.
# License: The MIT License

require 'ruby2d'
MAX_WIDTH  = 700
MAX_HEIGHT = 600

set title: "Triangle Game"


# Triangle.new(
#   x1: 320, y1:  50,
#   x2: 540, y2: 430,
#   x3: 100, y3: 430,
#   color: ['red', 'green', 'blue']
# )

OBJECT_SIZE = 32

msg = Text.new(x: 320, y: 240, text: 'Hi, Tres!', size: 20, font: '/Library/Fonts/Arial Rounded Bold.ttf')

player = Text.new(x: 0, y: 0, text: 'O', size: OBJECT_SIZE, font: '/Library/Fonts/Brush Script.ttf');


# Square.new(
#   x1: MAX_WIDTH, y1:  MAX_HEIGHT,
#   x2: MAX_WIDTH, y2: MAX_HEIGHT,
#   x3: MAX_WIDTH, y3: MAX_HEIGHT,
#   x4: MAX_WIDTH, y4: MAX_HEIGHT,
#   color: ['blue', 'blue', 'blue', 'blue']
# )

# Square.new(x: 100, y: 200, size:)
Rectangle.new(x: 0, y: MAX_HEIGHT - OBJECT_SIZE, width: MAX_WIDTH, height: OBJECT_SIZE, color: 'green')
# inventory_image = Text.new(x: 0, y: MAX_HEIGHT - OBJECT_SIZE, text: 'Inventory: ', size: OBJECT_SIZE, font: '/Library/Fonts/Brush Script.ttf');
inventory_items = []
objects_on_screen = [
  {display_name: 'Egg', x: OBJECT_SIZE * 4, y: OBJECT_SIZE * 8},
  {display_name: 'Bone', x: OBJECT_SIZE * 7, y: OBJECT_SIZE * 4}
]

objects_on_screen.each do |object|
  new_object = Text.new(x: object[:x], y: object[:y], text: 'X', size: OBJECT_SIZE, font: '/Library/Fonts/Brush Script.ttf');
  object[:reference] = new_object
  # Square.new(x: object[:x], y: object[:y], side: OBJECT_SIZE, color: 'orange')
end

def redraw_inventory inventory_items
  puts "redraw_inventory"
  puts inventory_items
  inventory_image = Text.new(x: 0, y: MAX_HEIGHT - OBJECT_SIZE, text: 'Inventory: ' + inventory_items.collect{|i| i[:display_name]}.join(', '), size: OBJECT_SIZE, font: '/Library/Fonts/Brush Script.ttf');
end

redraw_inventory(inventory_items)

# puts "inventryo: #{inventory.y}"

set width: MAX_WIDTH, height: MAX_HEIGHT

msg.x = MAX_WIDTH  # - msg.width / 2
msg.y = MAX_HEIGHT # - msg.height / 2

tick = 0
t = Time.now

continue_movement = false
last_direction = nil
tick_movement_delay = nil

def move_up player
  if (player.y - OBJECT_SIZE) >= 0
    player.y -= OBJECT_SIZE
  end
end

def move_down player
  if (player.y + OBJECT_SIZE) < MAX_HEIGHT - OBJECT_SIZE * 2
    player.y += OBJECT_SIZE
  end
end

def move_right player
  if (player.x + OBJECT_SIZE) <= MAX_WIDTH
    player.x += OBJECT_SIZE
  end
end

def move_left player
  if (player.x - OBJECT_SIZE) >= 0
    player.x -= OBJECT_SIZE
  end
end

def is_object_under_player player, objects_on_screen, inventory_items
  delete_objects = []
  objects_on_screen.each_with_index do |object, index|
    if (player.y == object[:y]) && (player.x == object[:x])
      inventory_items << object
      delete_objects << index
      # object[:reference].destroy
    end
  end
  delete_objects.each do |delete_object|
    objects_on_screen.delete_at(delete_object)
  end
end

on :key do |e|
  # puts e
  if e.type == :down
    puts "DOWN e.key: #{e.key}"
    case e.key
    when 's'
      move_down(player)
      last_direction = method(:move_down)
      tick_movement_delay = tick
      continue_movement = true
    when 'w'
      move_up(player)
      last_direction = method(:move_up)
      tick_movement_delay = tick
      continue_movement = true
    when 'a'
      move_left(player)
      last_direction = method(:move_left)
      tick_movement_delay = tick
      continue_movement = true
    when 'd'
      move_right(player)
      last_direction = method(:move_right)
      tick_movement_delay = tick
      continue_movement = true
    when 'q'
      close
    end
    is_object_under_player(player, objects_on_screen, inventory_items)
  end

  if e.type == :up
    puts "UP e.key: #{e.key}"
    continue_movement = false
  end
end

update do
  if tick % 60 == 0
    # set background: 'random'
    redraw_inventory(inventory_items)
  end
  if continue_movement && tick_movement_delay && tick > (tick_movement_delay + 30) && tick % 5 == 0 && last_direction
    last_direction.call(player)
    is_object_under_player(player, objects_on_screen, inventory_items)
  end
  tick += 1
  # Close the window after 5 seconds
  #if Time.now - t > 5 then close end
end

show
# will never get here
close
