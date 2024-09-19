require_relative '../../../game/base_entity'

module Game
  class Gnome < BaseEntity
    attr_accessor :target  
    attr_reader :image     

    def initialize(x = 0, y = 0, speed = 1, health = 50, damage_player = 1)
      super(x, y, speed, health, damage_player)
      @target = nil
      @image = Gosu::Image.new('lib/enemy/forest/gnome/sprite/gnome.png')
    end

    # ...
    def set_target(target)
      @target = target
    end

    # ...
    def update
      return unless @target # ...

      # ...
      target_x = @target.x
      target_y = @target.y

      # ...
      dx = target_x - @x
      dy = target_y - @y

      # ...
      distance = Math.sqrt(dx**2 + dy**2)
      return if distance == 0  # ...

      # ...
      if collides_with?(@target, 30)
        deal_damage_to_player
      else
        # ...
        step_x = (dx / distance) * @speed
        step_y = (dy / distance) * @speed

        # ...
        move(step_x, step_y)
      end
    end

    # ...
    def deal_damage_to_player
      if @target.health > 0
        if @target.defending_animation  # ...
          reduced_damage = @damage_player / 2  
          @target.health -= reduced_damage
          puts "The gnome attacks, but the player defends! Damage reduced to #{reduced_damage}. I've got my health: #{@target.health}"
        else
          @target.health -= @damage_player
          puts "A gnome is attacking a player! The player has health left: #{@target.health}"
        end
      else
        puts "The player is defeated!"
      end
    end

    # ...
    def draw
      @image.draw(@x, @y, 1)
    end
  end
end