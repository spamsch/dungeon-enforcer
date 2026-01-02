extends CharacterBody3D
## Dungeon creature with navigation-based movement.
##
## Moves to clicked positions using NavigationAgent3D pathfinding.

signal arrived_at_target

@export var movement_speed: float = 4.0
@export var rotation_speed: float = 10.0
@export var arrival_threshold: float = 0.3

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var selection_indicator: MeshInstance3D = $SelectionIndicator
@onready var body_mesh: MeshInstance3D = $Body

var is_moving: bool = false
var target_position: Vector3 = Vector3.ZERO


func _ready() -> void:
	nav_agent.path_desired_distance = arrival_threshold
	nav_agent.target_desired_distance = arrival_threshold
	nav_agent.navigation_finished.connect(_on_navigation_finished)
	selection_indicator.visible = false


func move_to(target: Vector3) -> void:
	target_position = target
	nav_agent.target_position = target
	is_moving = true
	selection_indicator.visible = true


func _physics_process(delta: float) -> void:
	if not is_moving:
		return

	if nav_agent.is_navigation_finished():
		_stop_moving()
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var direction := (next_path_pos - global_position).normalized()

	# Smooth rotation toward movement direction
	if direction.length() > 0.01:
		var target_rotation := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

	# Apply movement
	velocity = direction * movement_speed
	velocity.y = 0  # Keep on ground plane

	move_and_slide()

	# Bob animation while moving
	var bob := sin(Time.get_ticks_msec() * 0.01) * 0.05
	body_mesh.position.y = bob


func _stop_moving() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	selection_indicator.visible = false
	body_mesh.position.y = 0
	arrived_at_target.emit()


func _on_navigation_finished() -> void:
	_stop_moving()
