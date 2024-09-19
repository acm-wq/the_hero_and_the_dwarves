# This is the basic template for all creatures in this game
# Each creature has position, speed and health

module Game
  class BaseEntity
    attr_accessor :x, :y, :speed, :health, :strength, :dexterity, :intelligence, :constitution, :charisma, :resistance,
                  :luck, :race

    # Available races
    RACES = %w[Unknown Human Elf Dwarf Orc]

    def initialize(x = 0, y = 0, speed = 2, health = 100, strength = 0, dexterity = 0, intelligence = 0, constitution = 0,
                   charisma = 0, resistance = 0, luck = 0, race = 'Unknown')
      @x = x                        # X position of the entity
      @y = y                        # Y position of the entity
      @speed = speed                # Speed of the entity
      @health = health              # Health of the entity
      @strength = strength          # Strength of the entity
      @dexterity = dexterity        # Dexterity of the entity
      @intelligence = intelligence  #
      @constitution = constitution  #
      @charisma = charisma          #
      @resistance = resistance      #
      @luck = luck                  #
      @race = race                  #
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
