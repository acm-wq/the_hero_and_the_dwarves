require_relative '../game/base_entity'

module Game
  class Player < BaseEntity
    def initialize
      super(100, 100, 5, 100)  
      @font = Gosu::Font.new(30) 
    end

    def update
      handle_input
    end

    def draw
      @font.draw_text("Player", @x, @y, 0, 1.0, 1.0, Gosu::Color::WHITE)
    end

    private

    def handle_input
      # Reset the movement deltas
      dx = 0
      dy = 0

      # Handle WASD input for movement
      if Gosu.button_down?(Gosu::KbW)
        dy -= 1
      end
      if Gosu.button_down?(Gosu::KbS)
        dy += 1
      end
      if Gosu.button_down?(Gosu::KbA)
        dx -= 1
      end
      if Gosu.button_down?(Gosu::KbD)
        dx += 1
      end

      # Move the player based on input
      move(dx, dy) if dx != 0 || dy != 0
    end
  end
end