require 'gosu'
require 'json'
require 'ostruct'
require_relative '../player/player'
require_relative '../enemy/forest/gnome/gnome'
require_relative 'base_entity'
require_relative 'level'

module Game
  # Base options Game
  class BaseWindow < Gosu::Window
    WIDTH = 1280
    HEIGHT = 640

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

    def update; end

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
        when 0
          start_game
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

  class Run < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
      @player = Game::Player.new
      @level = Level.new(@player)
    end

    def update
      return if @level.win

      @player.update
      @level.update

      @level.win = true if @level.all_enemies_defeated?

      @player.attack_nearby_enemies(@level.enemies)
    end

    def draw
      @level.draw(self)
      @player.draw
    end

    def button_down(id)
      if @level.win
        @level.button_down(id)
      else
        case id
        when Gosu::KbReturn
          @level.reset_level if @level.win
        end
      end
    end
  end

  # Settings
  class Settings < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
    end

    def update; end

    def draw
      @font.draw_text('Settings', 100, 100, 0, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw_text('Press ESC to return to menu', 100, 200, 0, 1.0, 1.0, Gosu::Color::GRAY)
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
        close
        Game::Menu.new.show
      end
    end
  end
end
