extends "res://scene/4/construction.gd"


var guilds = []
var ramifications = []


func init_basic_setting() -> void:
	super.init_basic_setting()
	color = Global.color.legion["any"]


func set_guilds(indexs_: Array) -> void:
	for index in indexs_:
		var guild = mainland.guilds.get_child(index)
		guilds.append(guild)
		guild.legions.append(self)
