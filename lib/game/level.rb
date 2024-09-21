# lib/game/level/prolog/level.rb
require 'json'
require 'ostruct'
require_relative '../enemy/forest/gnome/gnome'

class Level
  attr_reader :enemies

  def initialize(player)
    @player = player
    @enemies = []
    load_level_data
    load_map('lib/map/forest/forest.json')
  end

  def load_level_data
    # ...
    @enemies << Game::Gnome.new(200, 200)
    @enemies << Game::Gnome.new(400, 400)
    @enemies.each { |gnome| gnome.set_target(@player) }
  end

  def load_map(filename)
    # ...
    map_data = JSON.parse(File.read(filename))

    # ...
    @map = OpenStruct.new(
      width: map_data['width'],
      height: map_data['height'],
      tilewidth: map_data['tilewidth'],
      tileheight: map_data['tileheight'],
      layers: map_data['layers'].map { |layer_data| OpenStruct.new(layer_data) }
    )
    @tileset = Gosu::Image.load_tiles('lib/map/forest/forest_demo_sprite.png', 128, 128)
  end

  def update
    @enemies.each(&:update)
    # ...
    @enemies.reject! { |gnome| gnome.health <= 0 }
  end

  def all_enemies_defeated?
    @enemies.empty?
  end

  def draw
    # ...
    @map.layers.each do |layer|
      layer.data.each_with_index do |tile_id, index|
        next if tile_id == 0 # ...

        x = (index % @map.width) * @map.tilewidth
        y = (index / @map.width) * @map.tileheight

        @tileset[tile_id - 1].draw(x, y, 0) 
      end
    end

    # ...
    @enemies.each(&:draw)
  end
end