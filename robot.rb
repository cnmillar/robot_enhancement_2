require './lib/custom_exceptions'

class Robot
	attr_reader :position, :items, :items_weight
	attr_accessor :equipped_weapon, :health

	def initialize
		@position = [0,0] 			# this instance is an incapsolated variable unless we add at attr_*
		@items = []
		@items_weight = 0
		@health = 100
		@equipped_weapon = nil
	end

	def move_left
		@position[0] -= 1
	end

	def move_right
		@position[0] += 1
	end

	def move_up
		@position[1] += 1
	end

	def move_down
		@position[1] -= 1
	end

	def pick_up(item)
		if (item.is_a? Weapon)
			@equipped_weapon = item
		elsif (item.is_a? BoxOfBolts) && (health <= 80)
			item.feed(self)
		elsif (@items_weight + item.weight) <= 250
			@items << item
			@items_weight += item.weight
		end
	end

	def wound(damage)
		@health >= damage ? @health -= damage : @health = 0
	end

	def heal(amount)
		raise RobotAlreadyDeadError if @health <= 0

		(@health + amount) < 100 ? @health += amount : @health = 100
	end

	def attack(enemy)
		raise UnattackableEnemy if enemy.is_a? Item

		if (@position[0] - enemy.position[0]).abs <= 1 && (@position[1] - enemy.position[1]).abs <= 1
			equipped_weapon ? @equipped_weapon.hit(enemy) : enemy.wound(5)
		elsif (@position[0] - enemy.position[0]).abs <= 2 && (@position[1] - enemy.position[1]).abs <= 2
			if equipped_weapon.is_a? Grenade
				enemy.wound(5) 
				@equipped_weapon = nil
			end
		end

	end

	# Do this instead of tracking items_weight as an instance variable
	# def items_weight
	# 	@items.inject { |sum| }
	# end

	# def heal!(amount)
	# 	raise RobotAlreadyDeadError if @health <= 0
	# 	(@health + amount) < 100 ? @health += amount : @health = 100		
	# end

	# def attack!(enemy)
	# 	raise UnattackableEnemy if enemy.is_a? Item
	# 	equipped_weapon ? @equipped_weapon.hit(enemy) : enemy.wound(5)
	# end
end
