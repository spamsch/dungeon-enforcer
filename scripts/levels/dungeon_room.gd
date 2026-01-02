extends Node3D
## Dungeon room controller.
##
## Handles click-to-move input and creature management.

@onready var camera: Camera3D = $CameraRig/Camera3D
@onready var click_marker: MeshInstance3D = $ClickMarker
@onready var floor_body: StaticBody3D = $NavigationRegion3D/Floor

var creature: CharacterBody3D = null
var click_marker_timer: float = 0.0

const FLOOR_COLLISION_LAYER: int = 2
const CLICK_MARKER_DURATION: float = 1.0


func _ready() -> void:
	if Engine.has_singleton("GameManager") or has_node("/root/GameManager"):
		GameManager.start_game()
	_spawn_creature()


func _spawn_creature() -> void:
	var creature_scene := preload("res://scenes/entities/creature/creature.tscn")
	creature = creature_scene.instantiate()
	creature.position = Vector3(0, 0.25, 0)
	add_child(creature)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_handle_click(event.position)


func _handle_click(screen_pos: Vector2) -> void:
	var from := camera.project_ray_origin(screen_pos)
	var direction := camera.project_ray_normal(screen_pos)
	var to := from + direction * 100.0

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = FLOOR_COLLISION_LAYER

	var result := space_state.intersect_ray(query)
	if result:
		var click_pos: Vector3 = result.position
		click_pos.y = 0.25  # Slightly above floor

		_show_click_marker(click_pos)

		if creature:
			creature.move_to(click_pos)


func _show_click_marker(pos: Vector3) -> void:
	click_marker.position = Vector3(pos.x, 0.3, pos.z)
	click_marker.visible = true
	click_marker_timer = CLICK_MARKER_DURATION


func _process(delta: float) -> void:
	if click_marker.visible:
		click_marker_timer -= delta
		if click_marker_timer <= 0:
			click_marker.visible = false
		else:
			# Pulse effect
			var scale_factor := 1.0 + 0.2 * sin(click_marker_timer * 10.0)
			click_marker.scale = Vector3(scale_factor, scale_factor, scale_factor)
