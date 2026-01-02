extends Node2D
## Main scene controller for Dungeon Enforcer.
##
## This is the entry point of the game.


func _ready() -> void:
	print("Dungeon Enforcer initialized")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_start_game()


func _start_game() -> void:
	print("Starting game...")
	get_tree().change_scene_to_file("res://scenes/levels/dungeon_room.tscn")
