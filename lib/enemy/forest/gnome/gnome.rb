module Game
  class Gnome < BaseEntity
    attr_accessor :target
    attr_reader :image

    def initialize(x = 0, y = 0, speed = 1, health = 50, damage_player = 1)
      super(x, y, speed, health, damage_player)
      @target = nil
      @image = Gosu::Image.new('lib/enemy/forest/gnome/sprite/gnome.png')
    end

    def set_target(target)
      @target = target
    end

    def update
      return unless @target

      attack(@target)  # Use the attack method from BaseEntity
    end

    def draw
      @image.draw(@x, @y, 1)
    end
  end
end