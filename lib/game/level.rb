require 'json'
require 'ostruct'
require_relative '../enemy/forest/gnome/gnome'
require_relative '../enemy/forest/boar/boar'

class Level
  attr_accessor :win
  attr_reader :enemies

  def initialize(player)
    @player = player
    @enemies = []
    @win = false
    @selected_attribute = nil
    @attributes = %i[strength dexterity intelligence]
    @generated_attributes = []
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
    generate_attributes if @generated_attributes.empty?

    font = Gosu::Font.new(50)
    y_offset = 200
    @generated_attributes.each_with_index do |attribute, index|
      message = "Press #{index + 1} to increase #{attribute.to_s.capitalize}"
      font.draw_text(message, 100, y_offset + index * 80, 0, 1.0, 1.0, Gosu::Color::WHITE)
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
    when :charisma
      @player.charisma += 1
    when :sword_skill
      @player.sword_skill += 1
    when :bow_skill
      @player.bow_skill += 1
    when :magic_skill
      @player.magic_skill += 1
    when :resistance
      @player.resistance += 1
    when :luck
      @player.luck += 1
    end
    reset_level
  end

  def reset_level
    @win = false
    @selected_attribute = nil
    @generated_attributes = []
    load_level_data
  end

  def select_attribute(index)
    return unless index.between?(1, @generated_attributes.length)

    @selected_attribute = @generated_attributes[index - 1]
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

  def generate_attributes
    @generated_attributes = []
    @generated_attributes << %i[strength dexterity intelligence].sample(2)

    non_standard_attributes = %i[charisma sword_skill bow_skill magic_skill luck] - @generated_attributes
    @generated_attributes << non_standard_attributes.sample(1)

    @generated_attributes.flatten!
  end
end
