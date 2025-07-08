extends Node2D

@onready var sceneTransitionAnimation = $Camera2D/screenTransitionAnimation/AnimationPlayer
@onready var camera = $Camera2D
var targetCameraZoom : float = 2.5
var zoomSpeed : float = 0.01

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	sceneTransitionAnimation.play("fadeOut")
	await get_tree().create_timer(0.5).timeout

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.5).timeout
	camera.zoom = camera.zoom.lerp(Vector2(targetCameraZoom, targetCameraZoom), zoomSpeed)
