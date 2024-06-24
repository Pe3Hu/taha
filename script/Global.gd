extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_scene()


func init_arr() -> void:
	arr.ennobled = ["settlement", "road"]
	arr.terrain = ["forest", "mountain", "plain"]
	arr.construction = ["legion", "guild", "ramification", "battlefield"]


func init_num() -> void:
	num.index = {}
	num.index.god = 0
	
	num.mainland = {}
	num.mainland.col = 25
	num.mainland.row = 25
	
	num.cell = {}
	num.cell.l = 32
	num.cell.a = num.cell.l / 2
	num.cell.r = num.cell.a * sqrt(2)
	
	num.construction = {}
	num.construction.l = num.cell.l * 3
	num.construction.a = num.construction.l / 2
	num.construction.r = num.construction.a * sqrt(2)
	
	num.settlement = {}
	num.settlement.gap = 3


func init_dict() -> void:
	init_direction()
	init_font()
	init_corner()
	
	init_construction()


func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.direction.linear = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.direction.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.direction.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_font():
	dict.font = {}
	dict.font.size = {}


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [4]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2*PI*_i/corners_-PI/2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_construction() -> void:
	dict.construction = {}
	dict.construction.index = {}
	dict.construction.type = {}
	var exceptions = ["index", "x", "y"]
	
	var path = "res://asset/json/taha_construction.json"
	var array = load_data(path)
	
	for construction in array:
		construction.index = int(construction.index)
		var data = {}
		data.grid = Vector2i(construction.x, construction.y)
		
		for key in construction:
			if !exceptions.has(key):
				if key.contains("put"):
					data[key] = []
					var words = construction[key].split(",")
					
					if !construction[key].contains(","):
						words = [construction[key]]
					
					for word in words:
						data[key].append(int(word))
				else:
					data[key] = construction[key]
	
		dict.construction.index[construction.index] = data
		
		if !dict.construction.type.has(data.type):
			dict.construction.type[data.type] = {}
		
		dict.construction.type[data.type][data.subtype] = construction.index


func init_scene() -> void:
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	
	scene.minion = load("res://scene/3/minion.tscn")
	
	scene.guild = load("res://scene/4/guild.tscn")
	scene.legion = load("res://scene/4/legion.tscn")
	scene.ramification = load("res://scene/4/ramification.tscn")
	scene.battlefield = load("res://scene/4/battlefield.tscn")
	


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.token = Vector2(vec.size.sixteen)
	vec.size.construction = Vector2.ONE * num.construction.l
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	
	color.guild = {}
	color.guild["horseman"] = Color.from_hsv(0 / h, 0.6, 0.7)
	color.guild["pikeman"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.guild["swordsman"] = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.legion = {}
	color.legion["any"] = Color.from_hsv(0 / h, 0.0, 0.7)
	
	color.ramification = {}
	color.ramification["first"] = Color.from_hsv(330 / h, 0.8, 0.7)
	color.ramification["second"] = Color.from_hsv(300 / h, 0.8, 0.7)
	color.ramification["third"] = Color.from_hsv(270 / h, 0.8, 0.7)
	color.ramification["fourth"] = Color.from_hsv(240 / h, 0.8, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
