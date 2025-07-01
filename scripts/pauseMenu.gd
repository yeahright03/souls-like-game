extends Control

var paused : bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true

	paused = !paused

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false
	paused = false

func _on_quit_pressed() -> void:
	hide()
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
