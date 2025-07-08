extends Node2D

@onready var sceneTransitionAnimation = $Camera2D/screenTransitionAnimation/AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _on_area_exit_body_entered(body:Node2D) -> void:
	if body.name == "player":
		sceneTransitionAnimation.play("fadeIn")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/areas/bossArea.tscn")
