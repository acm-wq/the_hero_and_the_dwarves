require 'gosu'
require_relative '../game/base_entity'

module Game
  class Player < BaseEntity
    def initialize
      super(100, 100, 5, 100)
      @font = Gosu::Font.new(30)

      @idle_sprites = [
        Gosu::Image.new('lib/player/sprite/player_idle_0.png'),
        Gosu::Image.new('lib/player/sprite/player_idle_1.png'),
        Gosu::Image.new('lib/player/sprite/player_idle_2.png'),
        Gosu::Image.new('lib/player/sprite/player_idle_3.png')
      ]

      @run_sprites = [
        Gosu::Image.new('lib/player/sprite/player_run_0.png'),
        Gosu::Image.new('lib/player/sprite/player_run_1.png')
      ]

      @sword_sprite = Gosu::Image.new('lib/player/sprite/sword_iron.png')

      @current_frame = 0
      @idle_animation = true
      @run_animation = false

      @frame_count = 0
      @frame_delay = 10
    end

    def update
      handle_input
      animate
    end

    def draw
      if @idle_animation
        @idle_sprites[@current_frame].draw(@x, @y, 0)
      elsif @run_animation
        @run_sprites[@current_frame].draw(@x, @y, 0)
      end

      # Draw the sword next to the player
      sword_x, sword_y = sword_position
      @sword_sprite.draw(sword_x, sword_y, 1)  
    end

    private

    def handle_input
      dx = 0
      dy = 0

      # WASD movement controls
      dy -= 1 if Gosu.button_down?(Gosu::KbW) or Gosu.button_down?(Gosu::KbUp)
      dy += 1 if Gosu.button_down?(Gosu::KbS) or Gosu.button_down?(Gosu::KbDown)
      dx -= 1 if Gosu.button_down?(Gosu::KbA) or Gosu.button_down?(Gosu::KbLeft)
      dx += 1 if Gosu.button_down?(Gosu::KbD) or Gosu.button_down?(Gosu::KbRight)

      # Check if player is moving
      @is_moving = dx != 0 || dy != 0
      
      # Move the player if they are moving
      move(dx, dy) if @is_moving

      # Check if the attack button is pressed (e.g., left mouse button)
      if Gosu.button_down?(Gosu::MsLeft)
        attack
      end
    end

    def sword_position
      # Position the sword to the right of the player
      sword_x = @x + 30  # Adjust the offset as needed
      sword_y = @y       # Same vertical position as player for now
      return sword_x, sword_y
    end

    def animate
      @frame_delay = 10

      if @frame_count % @frame_delay == 0
        @current_frame += 1
        if @idle_animation
          @current_frame %= @idle_sprites.size
        elsif @run_animation
          @current_frame %= @run_sprites.size
        end
      end

      @frame_count += 1
    end

    def attack
      # logic for attacking
      puts "Player attacks with sword!"
    end
  end
end