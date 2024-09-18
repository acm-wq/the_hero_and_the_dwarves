require_relative '../../../game/base_entity'

module Game
  class Gnome < BaseEntity
    attr_accessor :target  # player
    attr_reader :image     # sprite gnome

    def initialize(x = 0, y = 0, speed = 1, health = 50)
      super(x, y, speed, health)
      @target = nil
      @image = Gosu::Image.new('lib/enemy/forest/gnome/sprite/gnome.png')
    end

    # purpose
    def set_target(target)
      @target = target
    end

    # Update gnome
    def update
      return unless @target

      # X,Y Player
      target_x = @target.x
      target_y = @target.y

      # ...
      dx = target_x - @x
      dy = target_y - @y

      # ...
      distance = Math.sqrt(dx**2 + dy**2)
      return if distance == 0 # If gnome with player

      # ...
      step_x = (dx / distance) * @speed
      step_y = (dy / distance) * @speed

      # move
      move(step_x, step_y)
    end

    # draw
    def draw
      @image.draw(@x, @y, 1)
    end
  end
end
