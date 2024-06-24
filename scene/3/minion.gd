extends CharacterBody2D


#region var
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

var guild = null
var legion = null
var construction = null
var speed = 128
var power = 50
var direction : Vector2
var target = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	guild = input_.guild
	
	init_basic_setting()


func init_basic_setting() -> void:
	construction = guild.construction
	position = construction.get_local_position()
	
	print(construction.grid, position)


func pick_target() -> void:

	if legion == null:
		pick_legion()
	else:
		pass
	
	make_path()


func pick_legion() -> void:
	var weights = {}
	
	for _legion in guild.legions:
		weights[_legion] = 1
	
	legion = Global.get_random_key(weights)
	target = legion.construction
#endregion

func _physics_process(_delta: float) -> void:
	if target != null:
		if navigation_agent.is_target_reachable():
			direction = to_local(navigation_agent.get_next_path_position()).normalized()
	
	velocity = direction * speed
	move_and_slide()


func make_path() -> void:
	navigation_agent.target_position = target.get_global_position()# + conqueror.custom_minimum_size


func _on_timer_timeout():
	pick_target()


func _on_navigation_agent_2d_target_reached():
	construction = target
	pick_target()
