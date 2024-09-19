require 'gosu'
require_relative '../game/base_entity'
require_relative 'weapon'

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

      # Initialize the weapon
      @weapon = Weapon.new(
        10, # Damage
        'lib/player/sprite/sword_iron.png',
        [ # Attack animation sprites
          'lib/player/sprite/sword_iron_attack_0.png',
          'lib/player/sprite/sword_iron_attack_1.png',
          'lib/player/sprite/sword_iron_attack_2.png',
          'lib/player/sprite/sword_iron_attack_3.png'
        ],
        [ # Defence animation sprites
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
      @attack_frame = 0
      @defence_frame = 0
      @attack_frame_delay = 10
      @defence_frame_delay = 10
      @frame_count = 0
    end

    def update
      handle_input
      animate
    end

    def draw
      # Draw the player based on the current animation state
      if @attacking_animation
        draw_attack
      elsif @defending_animation
        draw_defence
      else
        draw_idle_or_run
        draw_weapon
      end
    end

    private

    def handle_input
      dx = 0
      dy = 0

      # WASD movement controls
      dy -= 1 if Gosu.button_down?(Gosu::KbW) || Gosu.button_down?(Gosu::KbUp)
      dy += 1 if Gosu.button_down?(Gosu::KbS) || Gosu.button_down?(Gosu::KbDown)
      dx -= 1 if Gosu.button_down?(Gosu::KbA) || Gosu.button_down?(Gosu::KbLeft)
      dx += 1 if Gosu.button_down?(Gosu::KbD) || Gosu.button_down?(Gosu::KbRight)

      # Check if player is moving
      @is_moving = dx != 0 || dy != 0

      # Move the player if they are moving
      move(dx, dy) if @is_moving

      # Update animation states
      if @is_moving
        @run_animation = true
        @idle_animation = false
      else
        @run_animation = false
        @idle_animation = true
      end

      # Check if the attack button (left mouse button) is pressed
      if Gosu.button_down?(Gosu::MsLeft) && !@attacking_animation && !@defending_animation
        attack
      end

      # Check if the defence button (right mouse button) is pressed
      if Gosu.button_down?(Gosu::MsRight) && !@defending_animation && !@attacking_animation
        defence
      end
    end

    def draw_attack
      # Draw the player
      draw_idle_or_run

      # Draw the current attack frame from the weapon on top
      if @attack_frame < @weapon.attack_sprites.size
        @weapon.attack_sprites[@attack_frame].draw(@x, @y, 1)
      end
    end

    def draw_defence
      draw_idle_or_run

      if @defence_frame < @weapon.defence_sprites.size
        @weapon.defence_sprites[@defence_frame].draw(@x, @y, 1)
      end
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
      else
        animate_idle_or_run
      end
      @frame_count += 1
    end

    def animate_attack
      if @frame_count % @attack_frame_delay == 0
        @attack_frame += 1
        if @attack_frame >= @weapon.attack_sprites.size
          @attacking_animation = false
          @attack_frame = 0
        end
      end
    end

    def animate_defence
      if @frame_count % @defence_frame_delay == 0
        @defence_frame += 1
        if @defence_frame >= @weapon.defence_sprites.size
          @defending_animation = false
          @defence_frame = 0
        end
      end
    end

    def animate_idle_or_run
      if @frame_count % 10 == 0
        if @run_animation
          @current_frame += 1
          @current_frame %= @run_sprites.size
        elsif @idle_animation
          @current_frame += 1
          @current_frame %= @idle_sprites.size
        end
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
      puts "Player defence!"
    end
  end
end