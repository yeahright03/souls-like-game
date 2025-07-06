extends Control

var paused : bool = false
@export var targetLevel : String

func _process(_delta: float) -> void:
	if game.playerHP <= 0:
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_repawn_pressed() -> void:
	hide()
	game.playerHP = 3
	get_tree().change_scene_to_file(targetLevel)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _on_quit_pressed() -> void:
	hide()
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
