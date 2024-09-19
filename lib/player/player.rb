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
        ]
      )

      @current_frame = 0
      @idle_animation = true
      @run_animation = false
      @attacking_animation = false
      @attack_frame = 0
      @attack_frame_delay = 10
      @frame_count = 0
    end

    def update
      handle_input
      animate
    end

    def draw
      if @attacking_animation
        # Draw the player first
        if @idle_animation
          @idle_sprites[@current_frame].draw(@x, @y, 0)
        elsif @run_animation
          @run_sprites[@current_frame].draw(@x, @y, 0)
        end
        # Then draw the current attack frame from the weapon on top
        @weapon.attack_sprites[@attack_frame].draw(@x, @y, 1)
      else
        if @idle_animation
          @idle_sprites[@current_frame].draw(@x, @y, 0)
        elsif @run_animation
          @run_sprites[@current_frame].draw(@x, @y, 0)
        end

        # Draw the weapon sprite
        sword_x, sword_y = weapon_position
        @weapon.sprite.draw(sword_x, sword_y, 1)
      end
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
      return unless Gosu.button_down?(Gosu::MsLeft) && !@attacking_animation

      attack
    end

    def weapon_position
      # Position the weapon to the right of the player
      sword_x = @x + 30
      sword_y = @y
      [sword_x, sword_y]
    end

    def animate
      if @attacking_animation
        # Handle attack frame animation
        if @frame_count % @attack_frame_delay == 0
          @attack_frame += 1
          if @attack_frame >= @weapon.attack_sprites.size
            # Reset the attack animation after the last frame
            @attacking_animation = false
            @attack_frame = 0
          end
        end
      else
        @frame_delay = 10

        if @frame_count % @frame_delay == 0
          @current_frame += 1
          if @idle_animation
            @current_frame %= @idle_sprites.size
          elsif @run_animation
            @current_frame %= @run_sprites.size
          end
        end
      end

      @frame_count += 1
    end

    def attack
      # Start the attack animation
      @attacking_animation = true
      @attack_frame = 0 # Reset the attack frame to start from the first frame
      puts "Player attacks with sword! (Damage: #{@weapon.damage})"
      # Additional logic for attack could go here (e.g., checking for hits)
    end
  end
end
