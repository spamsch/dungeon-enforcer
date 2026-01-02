extends Node
## Global game manager autoload.
##
## Handles game state, saves, and global settings.

signal game_started
signal game_paused
signal game_resumed

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.MENU


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_game() -> void:
	current_state = GameState.PLAYING
	game_started.emit()


func pause_game() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		game_paused.emit()


func resume_game() -> void:
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		game_resumed.emit()


func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		pause_game()
	elif current_state == GameState.PAUSED:
		resume_game()
