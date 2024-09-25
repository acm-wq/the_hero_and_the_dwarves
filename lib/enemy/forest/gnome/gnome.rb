module Game
  class Gnome < BaseEntity
    attr_accessor :target
    attr_reader :image

    ANIMATION_SPEED = 0.1
    SPRITE_COUNT = 4
    HIT_SPRITE_COUNT = 4

    def initialize(x = 0, y = 0, speed = 1, health = 50, damage_player = 1, _strength = 1, _dexterity = 1, _intelligence = 1,
                   _charisma = 0, _sword_skill = 0, _bow_skill = 0, _magic_skill = 0, _resistance = 1000, _luck = 3)
      super(x, y, speed, health, damage_player)
      @resistance = 10
      @target = nil

      @sprites = []
      SPRITE_COUNT.times do |i|
        @sprites << Gosu::Image.new("lib/enemy/forest/gnome/sprite/gnome_run_#{i}.png")
      end

      @hit_sprites = []
      HIT_SPRITE_COUNT.times do |i|
        @hit_sprites << Gosu::Image.new("lib/enemy/forest/gnome/sprite/gnome_hit_#{i}.png")
      end

      @current_sprite_index = 0
      @animation_time = 0
      @hit_animation_frame = 0
      @hit_animation_time = 0
      @previous_health = health
    end

    def set_target(target)
      @target = target
    end

    def update
      return unless @target

      if @health < @previous_health
        @hit_animation_time += ANIMATION_SPEED
        if @hit_animation_time >= 1
          @hit_animation_frame = (@hit_animation_frame + 1) % HIT_SPRITE_COUNT
          @hit_animation_time = 0
        end
        @previous_health = @health
      elsif collides_with?(@target)
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
      if @health < @previous_health
        @hit_sprites[@hit_animation_frame].draw(@x, @y, 1)
      else
        @sprites[@current_sprite_index].draw(@x, @y, 1)
      end
    end
  end
end
