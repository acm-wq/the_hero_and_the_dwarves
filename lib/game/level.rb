require 'json'
require 'ostruct'
require_relative '../enemy/forest/gnome/gnome'

class Level
  attr_accessor :win
  attr_reader :enemies

  def initialize(player)
    @player = player
    @enemies = []
    @win = false
    @selected_attribute = nil
    @attributes = %i[strength dexterity intelligence]
    load_level_data
    load_map('lib/map/forest/forest.json')

    @music = Gosu::Song.new('lib/sound/forest/Bhisar_Forest.wav')
    @music.play(true)
  end

  def load_level_data
    @enemies << Game::Gnome.new(200, 200)
    @enemies << Game::Gnome.new(400, 400)
    @enemies.each { |gnome| gnome.set_target(@player) }
  end

  def load_map(filename)
    map_data = JSON.parse(File.read(filename))
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
    return if @win # ...

    @enemies.each(&:update)
    @enemies.reject! { |gnome| gnome.health <= 0 && gnome.is_dead }

    @win = true if all_enemies_defeated?
  end

  def all_enemies_defeated?
    @enemies.empty?
  end

  def draw(window)
    draw_map
    @enemies.each(&:draw)

    return unless @win

    if @selected_attribute.nil?
      draw_win_message(window)
      draw_attribute_selection(window)
    else
      apply_attribute_selection
    end
  end

  def draw_map
    @map.layers.each do |layer|
      layer.data.each_with_index do |tile_id, index|
        next if tile_id == 0

        x = (index % @map.width) * @map.tilewidth
        y = (index / @map.width) * @map.tileheight

        @tileset[tile_id - 1].draw(x, y, 0)
      end
    end
  end

  def draw_win_message(window)
    font = Gosu::Font.new(100)
    message = 'Win!'
    width = font.text_width(message)
    height = font.height
    font.draw_text(message, (window.width - width) / 2, (window.height - height) / 2, 0, 1.0, 1.0, Gosu::Color::GREEN)
  end

  def draw_attribute_selection(_window)
    font = Gosu::Font.new(30)
    y_offset = 200
    @attributes.each_with_index do |attribute, index|
      message = "Press #{index + 1} to increase #{attribute.to_s.capitalize}"
      font.draw_text(message, 100, y_offset + index * 40, 0, 1.0, 1.0, Gosu::Color::WHITE)
    end
  end

  def apply_attribute_selection
    case @selected_attribute
    when :strength
      @player.strength += 1
    when :dexterity
      @player.dexterity += 1
    when :intelligence
      @player.intelligence += 1
    end
    reset_level
  end

  def reset_level
    @win = false
    @selected_attribute = nil
    load_level_data
  end

  def select_attribute(index)
    return unless index.between?(1, @attributes.length)

    @selected_attribute = @attributes[index - 1]
  end

  def button_down(id)
    return unless @win && @selected_attribute.nil?

    case id
    when Gosu::Kb1
      puts 'Strength selected'
      select_attribute(1)
    when Gosu::Kb2
      puts 'Dexterity selected'
      select_attribute(2)
    when Gosu::Kb3
      puts 'Intelligence selected'
      select_attribute(3)
    end
  end
end