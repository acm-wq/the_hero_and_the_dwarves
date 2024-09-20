require 'gosu'
require_relative '../game/base_entity'
require_relative 'weapon'

module Game
  class Player < BaseEntity
    attr_reader :defending_animation

    def initialize
      super(100, 100, 5, 100) # ...
      @font = Gosu::Font.new(30) # ...

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

      @hit_sprites = [
        Gosu::Image.new('lib/player/sprite/player_hit_0.png'),
        Gosu::Image.new('lib/player/sprite/player_hit_1.png'),
        Gosu::Image.new('lib/player/sprite/player_hit_2.png'),
        Gosu::Image.new('lib/player/sprite/player_hit_3.png')
      ]

      # ...
      @weapon = Weapon.new(
        10, # ...
        'lib/player/sprite/sword_iron.png',
        [ # ...
          'lib/player/sprite/sword_iron_attack_0.png',
          'lib/player/sprite/sword_iron_attack_1.png',
          'lib/player/sprite/sword_iron_attack_2.png',
          'lib/player/sprite/sword_iron_attack_3.png'
        ],
        [ # ...
          'lib/player/sprite/sword_iron_defence_0.png',
          'lib/player/sprite/sword_iron_defence_1.png',
          'lib/player/sprite/sword_iron_defence_2.png',
          'lib/player/sprite/sword_iron_defence_3.png'
        ]
      )

      @current_frame = 0
      @idle_animation = true
      @run_animation = false
      @attacking_animation = false
      @defending_animation = false
      @hit_animation = false
      @attack_frame = 0
      @defence_frame = 0
      @hit_frame = 0
      @attack_frame_delay = 10
      @defence_frame_delay = 10
      @hit_frame_delay = 10
      @frame_count = 0

      @previous_health = @health
    end

    def update
      handle_input
      animate

      if @health < @previous_health
        @hit_animation = true
        @previous_health = @health
      end

      puts "Здоровье игрока: #{@health}" if @health <= 50
    end

    def draw
      draw_health

      if @attacking_animation
        draw_attack
      elsif @defending_animation
        draw_defence
      elsif @hit_animation
        draw_hit
      else
        draw_idle_or_run
        draw_weapon
      end
    end

    def draw_health
      @font.draw_text("HP: #{@health}", 10, 10, 2, 1.0, 1.0, Gosu::Color::WHITE)
    end

    private

    def handle_input
      dx = 0
      dy = 0

      dy -= 1 if Gosu.button_down?(Gosu::KbW) || Gosu.button_down?(Gosu::KbUp)
      dy += 1 if Gosu.button_down?(Gosu::KbS) || Gosu.button_down?(Gosu::KbDown)
      dx -= 1 if Gosu.button_down?(Gosu::KbA) || Gosu.button_down?(Gosu::KbLeft)
      dx += 1 if Gosu.button_down?(Gosu::KbD) || Gosu.button_down?(Gosu::KbRight)

      @is_moving = dx != 0 || dy != 0

      move(dx, dy) if @is_moving

      if @is_moving
        @run_animation = true
        @idle_animation = false
      else
        @run_animation = false
        @idle_animation = true
      end

      attack if Gosu.button_down?(Gosu::MsLeft) && !@attacking_animation && !@defending_animation

      return unless Gosu.button_down?(Gosu::MsRight) && !@defending_animation && !@attacking_animation

      defence
    end

    def draw_attack
      draw_idle_or_run

      return unless @attack_frame < @weapon.attack_sprites.size

      @weapon.attack_sprites[@attack_frame].draw(@x, @y, 1)
    end

    def draw_defence
      draw_idle_or_run

      return unless @defence_frame < @weapon.defence_sprites.size

      @weapon.defence_sprites[@defence_frame].draw(@x, @y, 1)
    end

    def draw_hit
      return unless @hit_frame < @hit_sprites.size

      @hit_sprites[@hit_frame].draw(@x, @y, 0)
    end

    def draw_idle_or_run
      if @run_animation && !@run_sprites.empty?
        @run_sprites[@current_frame % @run_sprites.size].draw(@x, @y, 0)
      elsif @idle_animation && !@idle_sprites.empty?
        @idle_sprites[@current_frame % @idle_sprites.size].draw(@x, @y, 0)
      end
    end

    def draw_weapon
      sword_x, sword_y = weapon_position
      @weapon.sprite.draw(sword_x, sword_y, 1) if @weapon.sprite
    end

    def weapon_position
      sword_x = @x + 30
      sword_y = @y + 10
      [sword_x, sword_y]
    end

    def animate
      if @attacking_animation
        animate_attack
      elsif @defending_animation
        animate_defence
      elsif @hit_animation
        animate_hit
      else
        animate_idle_or_run
      end
      @frame_count += 1
    end

    def animate_attack
      return unless @frame_count % @attack_frame_delay == 0

      @attack_frame += 1
      return unless @attack_frame >= @weapon.attack_sprites.size

      @attacking_animation = false
      @attack_frame = 0
    end

    def animate_defence
      return unless @frame_count % @defence_frame_delay == 0

      @defence_frame += 1
      return unless @defence_frame >= @weapon.defence_sprites.size

      @defending_animation = false
      @defence_frame = 0
    end

    def animate_hit
      return unless @frame_count % @hit_frame_delay == 0

      @hit_frame += 1
      return unless @hit_frame >= @hit_sprites.size

      @hit_animation = false
      @hit_frame = 0
    end

    def animate_idle_or_run
      return unless @frame_count % 10 == 0

      if @run_animation
        @current_frame += 1
        @current_frame %= @run_sprites.size
      elsif @idle_animation
        @current_frame += 1
        @current_frame %= @idle_sprites.size
      end
    end

    def attack
      @attacking_animation = true
      @attack_frame = 0
      puts "Player attack! (Damage: #{@weapon.damage})"
    end

    def defence
      @defending_animation = true
      @defence_frame = 0
      puts 'Player defence!'
    end
  end
end
