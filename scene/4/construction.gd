extends Polygon2D


#region var
var construction = null
var mainland = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	mainland = construction.mainland
	position = construction.get_local_position()
	set_vertexs()


func set_vertexs() -> void:
	var order = "odd"
	var corners = 4
	var r = Global.num.construction.r
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)
#endregion
