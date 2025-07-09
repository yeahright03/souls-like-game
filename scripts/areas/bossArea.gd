extends Node2D

@onready var sceneTransitionAnimation = $Camera2D/screenTransitionAnimation/AnimationPlayer
@onready var camera = $Camera2D
@onready var player = $player
@onready var boss = $enemies/"Prototype-boss"
@onready var guard1 = $guards/guard1
@onready var guard2 = $guards/guard2
@onready var guardBlockageCollision = $guards/guardBlockage/CollisionShape2D
var targetCameraZoom : float = 2.5
var zoomSpeed : float = 0.01
var zoomInProgress : bool = false
var seenCutscene : bool = false
var cutsceneFinished : bool = false
var panDuration : float = 2
var panElapsed : float = 0
var panStart : Vector2 = Vector2.ZERO
var panTarget : Vector2 = Vector2.ZERO
var isPanning : bool = false

func _ready() -> void:
	seenCutscene = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	sceneTransitionAnimation.play("fadeOut")
	await get_tree().create_timer(0.5).timeout
	zoomInProgress = true
	guardBlockageCollision.disabled = true

func _process(delta: float) -> void:
	if zoomInProgress:
		camera.zoom = camera.zoom.lerp(Vector2(targetCameraZoom, targetCameraZoom), zoomSpeed)
		if camera.zoom == Vector2(targetCameraZoom, targetCameraZoom):
			zoomInProgress = false

	if isPanning:
		panElapsed += delta
		var time : float = clamp(panElapsed / panDuration, 0, 1)
		camera.offset = panStart.lerp(panTarget, time)

		if time >= 1:
			isPanning = false
			await get_tree().create_timer(panDuration/2).timeout
			setupGuard()
			if not cutsceneFinished:
				returnCamera()
				await get_tree().create_timer(panDuration/2).timeout
				player.canMove = true
				cutsceneFinished = true

func _on_boss_cutscene_body_entered(body: Node2D) -> void:
	if body == player and not seenCutscene:
		seenCutscene = true
		player.canMove = false
		player.velocity = Vector2.ZERO

		# sets up camera pan
		panStart = camera.offset
		panTarget = boss.global_position - camera.global_position
		panElapsed = 0
		isPanning = true

func returnCamera():
	panStart = camera.offset
	panTarget = Vector2.ZERO
	panElapsed = 0
	isPanning = true

func setupGuard():
	guard1.global_position = Vector2(-9, -720)
	guard2.global_position = Vector2(12, -720)
	guardBlockageCollision.disabled = false
