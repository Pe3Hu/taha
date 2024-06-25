extends MarginContainer


#region var
@onready var bar = $TextureProgressBar

var proprietor = null
var tween = null
var duration = null
#endregion

#region init

func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	duration = input_.value
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.cooldown
	bar.max_value = duration


#func update_duration() -> void:
	#if duration > 0:
		#bar.max_value = value
	#else:
		#bar.max_value = 0
		#bar.visible = false


func start() -> void:
	tween = create_tween()
	tween.tween_property(bar, "value", bar.max_value, bar.max_value)
	tween.tween_callback(end)


func end() -> void:
	bar.value = 0
	proprietor.end_of_cooldown()
#endregion
