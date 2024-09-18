module Game
  class BaseEntity
    attr_accessor :x, :y, :speed, :health

    def initialize(x = 0, y = 0, speed = 5, health = 100)
      @x = x            # X position of the entity
      @y = y            # Y position of the entity
      @speed = speed    # Speed of the entity
      @health = health  # Health of the entity
    end

    def move(dx, dy)
      @x += dx * @speed
      @y += dy * @speed
    end

    def draw
      # Placeholder for drawing the entity
      # This method should be overridden in subclasses
    end
  end
end