extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/areas/templeArea01.tscn")
	game.playerHP = 3
