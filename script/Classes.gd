extends Node


class Construction:
	var mainland = null
	var index = null
	var grid = null
	var type = null
	var subtype = null
	var inputs = []
	var outputs = []
	var scene = null
	
	func _init(input_: Dictionary) -> void:
		mainland = input_.mainland
		index = input_.index
	
		init_basic_setting()


	func init_basic_setting() -> void:
		var description = Global.dict.construction.index[index]
		grid = Vector2i(description.grid)
		type = description.type
		subtype = description.subtype
		
		if !mainland.constructions.has(type):
			mainland.constructions[type] = []
		
		mainland.constructions[type].append(self)
		mainland.grids[grid] = self
		init_scene()


	func init_scene() -> void:
		var input = {}
		input.construction = self
		scene = Global.scene[type].instantiate()
		var node = mainland.get(type+"s")
		node.add_child(scene)
		scene.set_attributes(input)


	func get_local_position() -> Vector2:
		var result = mainland.map.map_to_local(grid)
		result -= Vector2.ONE * Global.num.cell.l 
		#result.y -= Global.num.cell.l
		return result


	func get_global_position() -> Vector2:
		return mainland.to_global(mainland.map.map_to_local(grid))


class Conqueror:
	var god = null
	var mainland = null
	var settlements = []
	var roads = []
	var zones = []
	var frontiers = []
	var minions = []
	
	func _init(input_: Dictionary) -> void:
		god = input_.god
	
		#init_basic_setting()


	func init_basic_setting() -> void:
		mainland = god.planet.mainland
		#roll_settlement()
		#add_minion()


	func roll_settlement() -> void:
		var options = []
		var l = Global.num.mainland.rings - Global.num.settlement.gap
		
		for direction in Global.dict.direction.diagonal:
			var grid = Vector2i(direction) * l
			var spot = mainland.grids[grid]
			
			if spot.zone.conqueror == null:
				options.append(spot)
		
		var settlement = options.pick_random()
		settlement.zone.change_influence(self, settlement.zone.volume)


	func annex_zone(zone_: Polygon2D) -> void:
		zone_.conqueror = self
		zone_.recolor_based_on_god()
		
		var spots = get(zone_.spot.type + "s") 
		spots.append(zone_.spot)
		
		frontiers.erase(zone_)
		zones.append(zone_)
		
		for neighbor in zone_.neighbors:
			if !frontiers.has(neighbor) and !zones.has(neighbor):
				frontiers.append(neighbor)


	func forfeit_zone(zone_: Polygon2D) -> void:
		zone_.conqueror = null
		
		var spots = get(zone_.spot.type + "s") 
		spots.erase(zone_.spot)
		
		zones.erase(zone_)
		frontiers.append(zone_)
		
		for neighbor in zone_.neighbors:
			var flag = false
			
			for _neighbor in neighbor.neighbors:
				if zones.has(_neighbor):
					flag = true
			
			if !flag:
				frontiers.erase(neighbor)


	func add_minion() -> void:
		var input = {}
		input.conqueror = self
		input.spot = settlements.pick_random()
		
		var minion = Global.scene.minion.instantiate()
		mainland.planet.minions.add_child(minion)
		minion.set_attributes(input)
		minions.append(minion)
