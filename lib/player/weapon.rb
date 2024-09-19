module Game
  class Weapon
    attr_reader :damage, :sprite, :attack_sprites, :defence_sprites

    def initialize(damage, sprite_path, attack_sprites_paths, defence_sprites_paths)
      @damage = damage
      load_sprites(sprite_path, attack_sprites_paths, defence_sprites_paths)
      @attack_frame = 0
      @defence_frame = 0
      @attack_frame_delay = 10
      @defence_frame_delay = 10
      @frame_count = 0
    end

    def update
      animate_attack if @attacking
      animate_defence if @defencing
    end

    def draw
      if @attacking
        @attack_sprites[@attack_frame].draw(@x, @y, 0)
      elsif @defencing
        @defence_sprites[@defence_frame].draw(@x, @y, 0)
      else
        @sprite.draw(@x, @y, 1)
      end
    end

    def attack
      @attacking = true
      @attack_frame = 0
    end

    def defence
      @defencing = true
      @defence_frame = 0
    end

    private

    def load_sprites(sprite_path, attack_sprites_paths, defence_sprites_paths)
      @sprite = Gosu::Image.new(sprite_path)
      @attack_sprites = attack_sprites_paths.map { |path| Gosu::Image.new(path) }
      @defence_sprites = defence_sprites_paths.map { |path| Gosu::Image.new(path) }
    end

    def animate_attack
      if @frame_count % @attack_frame_delay == 0
        @attack_frame += 1
        if @attack_frame >= @attack_sprites.size
          @attacking = false
          @attack_frame = 0
        end
      end
      @frame_count += 1
    end

    def animate_defence
      if @frame_count % @defence_frame_delay == 0
        @defence_frame += 1
        if @defence_frame >= @defence_sprites.size
          @defencing = false
          @defence_frame = 0
        end
      end
      @frame_count += 1
    end
  end
end