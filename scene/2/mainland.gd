extends Node2D


#region var
@onready var map = $Map
@onready var guilds = $Constructions/Guilds
@onready var legions = $Constructions/Legions
@onready var ramifications = $Constructions/Ramifications
@onready var battlefields = $Constructions/Battlefields
@onready var minions = $Minions

var planet = null
var grids = {}
var constructions = {}
var layer = {}
var source = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	var l = Global.num.cell.l
	planet.custom_minimum_size = Vector2(Global.num.mainland.col, Global.num.mainland.row) * l
	$Constructions.position = Vector2.ONE * 8 / 16 * l
	minions.position = Vector2.ONE * 8 / 16 * l
	
	layer.floor = 0
	source = 0
	
	init_constructions()
	init_roads()
	init_minions()


func init_constructions() -> void:
	for index in Global.dict.construction.index:
		add_construction(index)


func add_construction(index_: int) -> void:
	var description = Global.dict.construction.index[index_]
	var input = {}
	input.mainland = self
	input.index = index_
	
	var y = Global.dict.construction.type.keys().find(description.type)
	var x = Global.dict.construction.type[description.type].keys().find(description.subtype)
	var atlas_coord = Vector2i(x, y)
	
	map.set_cell(layer.floor, description.grid, source, atlas_coord)
	var _construction = Classes.Construction.new(input)


func init_roads() -> void:
	init_outputs()
	var atlas_coord = Vector2i(0, 4)
	
	for type in Global.arr.construction:
		for construction in constructions[type]:
			for output in construction.outputs:
				var direction = Vector2(output.grid - construction.grid)
				direction = Vector2i(sign(direction.x), sign(direction.y))
				var directions = []
				directions.append(Vector2i(0, direction.y))
				directions.append(Vector2i(direction.x, 0))
				
				if direction.y == 0:
					directions.pop_front()
					
				if direction.x == 0:
					directions.pop_back()
					
				var grid = Vector2i(construction.grid )
				var end = Vector2i(output.grid)
				
				while grid + directions.front() != end:
					grid += directions.front()
					map.set_cell(layer.floor, grid, source, atlas_coord)
					
					if directions.size() > 1:
						if grid.y == end.y:
							directions.pop_front()


func init_outputs() -> void:
	for type in Global.arr.construction:
		for construction in constructions[type]:
			if Global.dict.construction.index[construction.index].has("output"):
				var outputs = Global.dict.construction.index[construction.index].output
				
				for index in outputs:
					var output = get_construction_based_on_index(index)
					construction.outputs.append(output)
					output.inputs.append(construction)
					
					var childs = construction.scene.get(output.type+"s")
					childs.append(output.scene)


func get_construction_based_on_index(index_: int) -> Variant:
	var construction = null
	var description = Global.dict.construction.index[index_]
	construction = grids[description.grid]
	return construction
#endregion


func init_minions() -> void:
	var guild = guilds.get_child(0)
	guild.spawn_minion()
