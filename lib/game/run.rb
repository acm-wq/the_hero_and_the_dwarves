require 'gosu'

module Game
  # Base options Game
  class BaseWindow < Gosu::Window
    WIDTH = 1280
    HEIGHT = 720

    def initialize
      super WIDTH, HEIGHT
      self.caption = 'More dungeons please'
    end
  end

  # Menu game
  class Menu < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
      @menu_items = %w[Play Settings]
      @current_item = 0
      @background_image = Gosu::Image.new('lib/game/sprite/menu.jpg')
    end

    def update
      # ...
    end

    def draw
      @background_image.draw(0, 0, 0)
      @font.draw_text('Welcome to the Game!', 100, 100, 0)
      @menu_items.each_with_index do |item, index|
        y_position = 200 + index * 60
        color = index == @current_item ? Gosu::Color::YELLOW : Gosu::Color::WHITE
        @font.draw_text(item, 100, y_position, 0, 1.0, 1.0, color)
      end
    end

    def button_down(id)
      case id
      when Gosu::KbUp
        @current_item = (@current_item - 1) % @menu_items.size
      when Gosu::KbDown
        @current_item = (@current_item + 1) % @menu_items.size
      when Gosu::KbReturn
        case @current_item
        # Play
        when 0
          start_game
        # Settings
        when 1
          open_settings
        end
      end
    end

    def start_game
      Game::Run.new.show
      close
    end

    def open_settings
      Game::Settings.new.show
    end
  end

  # Run base game
  class Run < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
    end

    def update
      # ...
    end

    def draw
      @font.draw_text('Game', 100, 100, 0)
    end
  end

  # Settings
  class Settings < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
    end

    def update
      # ...
    end

    def draw
      @font.draw_text('Settings', 100, 100, 0)
      @font.draw_text('Press ESC to return to menu', 100, 200, 0)
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
        # Restart in menu
        close
        Game::Menu.new.show
      end
    end
  end
end
