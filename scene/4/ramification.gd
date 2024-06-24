extends "res://scene/4/construction.gd"


var ramifications = []
var battlefields = []


func init_basic_setting() -> void:
	super.init_basic_setting()
	color = Global.color.ramification[construction.subtype]


func set_vertexs() -> void:
	super.set_vertexs()
	var order = "odd"
	var corners = 4
	var r = Global.num.construction.r
	var a = Global.num.construction.a / 3 * 2 
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	vertexs[0].x -= a
	vertexs[1].x -= a
	vertexs[2].x += a
	vertexs[3].x += a
	set_polygon(vertexs)
