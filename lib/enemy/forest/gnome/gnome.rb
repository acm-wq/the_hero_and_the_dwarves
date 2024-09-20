module Game
  class Gnome < BaseEntity
    attr_accessor :target
    attr_reader :image

    ANIMATION_SPEED = 0.1
    SPRITE_COUNT = 4

    def initialize(x = 0, y = 0, speed = 1, health = 50, damage_player = 1)
      super(x, y, speed, health, damage_player)
      @target = nil

      @sprites = []
      SPRITE_COUNT.times do |i|
        @sprites << Gosu::Image.new("lib/enemy/forest/gnome/sprite/gnome_run_#{i}.png")
      end

      @current_sprite_index = 0
      @animation_time = 0
    end

    def set_target(target)
      @target = target
    end

    def update
      return unless @target

      if collides_with?(@target)
        attack(@target)
        @current_sprite_index = 0
        @animation_time = 0
      else
        @animation_time += ANIMATION_SPEED
        if @animation_time >= 1
          @current_sprite_index = (@current_sprite_index + 1) % SPRITE_COUNT
          @animation_time = 0
        end
        move_towards(@target)
      end
    end

    def draw
      @sprites[@current_sprite_index].draw(@x, @y, 1)
    end
  end
end
