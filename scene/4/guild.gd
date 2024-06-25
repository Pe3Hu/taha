extends "res://scene/4/construction.gd"


#region Новая область кода
@onready var common = $Common
@onready var uncommon = $Uncommon
@onready var rare = $Rare
@onready var cooldown = $Cooldown

var minions = []
var legions = []
#endregion


func init_basic_setting() -> void:
	super.init_basic_setting()
	color = Global.color.guild[construction.subtype]
	init_tokens()


func init_tokens() -> void:
	var keys = []
	keys.append_array(Global.arr.rarity)
	keys.insert(1, "cooldown")
	var input = {}
	input.proprietor = self
	input.value = 1
	cooldown.set_attributes(input)
	cooldown.custom_minimum_size = Global.vec.size.cell
	
	for type in Global.arr.rarity:
		input.type = "rarity"
		input.subtype = type
		var token = get(type)
		token.set_attributes(input)
	
	for _i in keys.size():
		var direction = Global.dict.direction.diagonal[_i]
		var key = keys[_i]
		var node = get(key)
		node.position = (direction - Vector2.ONE * 0.5) * Global.vec.size.cell


func end_of_cooldown() -> void:
	spawn_minion()


func spawn_minion() -> void:
	var input = {}
	input.guild = self
	
	var minion = Global.scene.minion.instantiate()
	mainland.minions.add_child(minion)
	minion.set_attributes(input)
	minions.append(minion)
