module Game
  class BaseEntity
    attr_accessor :x, :y, :speed, :health, :strength, :dexterity, :intelligence, :constitution, :charisma, :resistance,
                  :luck, :race, :damage_player

    RACES = %w[Unknown Human Elf Dwarf Orc]

    def initialize(x = 0, y = 0, speed = 2, health = 100, damage_player = 0, strength = 0, dexterity = 0, intelligence = 0, constitution = 0,
                   charisma = 0, resistance = 0, luck = 0, race = 'Unknown')
      @x = x
      @y = y
      @speed = speed
      @base_speed = speed
      @health = health
      @damage_player = damage_player
      @strength = strength
      @dexterity = dexterity
      @intelligence = intelligence
      @constitution = constitution
      @charisma = charisma
      @resistance = resistance
      @luck = luck
      @race = race
    end

    def speed_with_dexterity
      @base_speed + (@dexterity / 10.0)
    end
    
    def move(dx, dy)
      @x += dx * speed_with_dexterity
      @y += dy * speed_with_dexterity
    end

    def draw  
      # Placeholder for drawing the entity
      # This method should be overridden in subclasses
    end

    def distance_to(other_entity)
      Math.sqrt((@x - other_entity.x)**2 + (@y - other_entity.y)**2)
    end

    def collides_with?(other_entity, collision_distance = 30)
      distance_to(other_entity) < collision_distance
    end

    # New methods for attack logic
    def attack(target, collision_distance = 30)
      return unless target.health > 0

      if collides_with?(target, collision_distance)
        deal_damage_to(target)
      else
        move_towards(target)
      end
    end

    private

    def deal_damage_to(target)
      if target.defending_animation
        reduced_damage = @damage_player / 2
        target.health -= reduced_damage
        puts "The attack was defended! Damage reduced to #{reduced_damage}. Target's health: #{target.health}"
      else
        target.health -= @damage_player
        puts "Attacked successfully! Target's health left: #{target.health}"
      end

      puts 'The target is defeated!' if target.health <= 0
    end

    def move_towards(target)
      dx = target.x - @x
      dy = target.y - @y
      distance = Math.sqrt(dx**2 + dy**2)
      return if distance == 0

      step_x = (dx / distance) * @speed
      step_y = (dy / distance) * @speed

      move(step_x, step_y)
    end
  end
end
