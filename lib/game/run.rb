# frozen_string_literal: true

require 'gosu'
require 'json'
require 'ostruct' 
require_relative '../player/player'
require_relative '../enemy/forest/gnome/gnome'
require_relative 'base_entity'

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

  class Run < BaseWindow
    def initialize
      super
      @font = Gosu::Font.new(50)
      @player = Player.new
      @gnome = Gnome.new(100, 100)
      @gnome.set_target(@player) 
  
      # Load the map
      @map = load_map('lib/map/forest/forest.json')
      @tileset = Gosu::Image.load_tiles('lib/map/forest/forest_demo_sprite.png', 128, 128) 
    end
  
    def update
      @player.update
      @gnome.update
    end
  
    def draw
      # Draw the map
      @map.layers.each do |layer|
        layer.data.each_with_index do |tile_id, index|
          next if tile_id == 0 # Skip empty tiles
  
          x = (index % @map.width) * @map.tilewidth
          y = (index / @map.width) * @map.tileheight
  
          @tileset[tile_id - 1].draw(x, y, 0) # Tile IDs start from 1
        end
      end
  
      @player.draw
      @gnome.draw
    end
  
    private
  
    def load_map(filename)
      # Load the JSON map data
      map_data = JSON.parse(File.read(filename))
  
      # Create a simple map object (you might want to use a more robust structure)
      OpenStruct.new(
        width: map_data['width'],
        height: map_data['height'],
        tilewidth: map_data['tilewidth'],
        tileheight: map_data['tileheight'],
        layers: map_data['layers'].map { |layer_data| OpenStruct.new(layer_data) }
      )
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