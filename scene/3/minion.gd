extends CharacterBody2D


#region var
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

var mainland = null
var guild = null
var legion = null
var ramification = null
var construction = null
var speed = 128#512
var direction : Vector2
var target = null
var tween = null
var grid = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	guild = input_.guild
	
	init_basic_setting()


func init_basic_setting() -> void:
	mainland = guild.mainland
	var path = "res://asset/png/minion/" + guild.construction.subtype + ".png"
	sprite.texture = load(path)
	construction = guild.construction
	position = construction.get_local_position()
	grid = Vector2i(construction.grid)
	mainland.grids[grid] = self


func pick_target() -> void:
	var weights = Dictionary(construction.weights)
	
	target = Global.get_random_key(weights)
	
	match target.type:
		"legion":
			legion = target
	
	make_path()
#endregion


func _physics_process(_delta: float) -> void:
	if target != null:
		if navigation_agent.is_target_reachable():
			direction = to_local(navigation_agent.get_next_path_position()).normalized()
		
		var gap = Vector2i(sign(direction.x), sign(direction.y))
		var next = grid + gap
		
		if !mainland.grids.has(next):
			pass
		else:
			print([grid, next], mainland.grids[next])
		
		if mainland.grids[next] == null or mainland.grids[next] == self:
			if mainland.grids[next] == null:
				mainland.grids[next] = self
			
			if direction != Vector2.ZERO:
				velocity = direction * speed
				move_and_slide()
				
				var _grid = position / Global.num.cell.l
				_grid.x = floor(_grid.x)
				_grid.y = floor(_grid.y)
				
				if Vector2i(_grid) != grid:
					mainland.grids[grid] = null
					grid = Vector2i(_grid)
					mainland.grids[grid] = self


func make_path() -> void:
	if target != null:
		navigation_agent.target_position = target.get_global_position()# + conqueror.custom_minimum_size


func _on_timer_timeout():
	pick_target()


func _on_navigation_agent_2d_target_reached():
	parking()


func parking() -> void:
	tween = create_tween()
	var distance = target.get_local_position() - position
	var _time = float(distance.length_squared()) / speed / 60
	tween.tween_property(self, "position", target.get_local_position(), _time).from(position)
	tween.tween_callback(rest)


func rest() -> void:
	construction = target
	direction = Vector2.ZERO
	
	if construction.type != "battlefield":
		mainland.grids[grid] = null
		pick_target()
