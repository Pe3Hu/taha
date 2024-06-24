extends "res://scene/4/construction.gd"


var minions = []
var legions = []


func init_basic_setting() -> void:
	super.init_basic_setting()
	color = Global.color.guild[construction.subtype]


func spawn_minion() -> void:
	var input = {}
	input.guild = self
	
	var minion = Global.scene.minion.instantiate()
	mainland.minions.add_child(minion)
	minion.set_attributes(input)
	minions.append(minion)
