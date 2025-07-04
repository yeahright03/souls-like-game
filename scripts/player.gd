extends CharacterBody2D

@export var dodgeSpeed : float = 400 # determines how fast dodge is
@export var dodgeTime : float = 0.5 # determines how long dodge is
var currentDodgeTime : float = 0
@export var dodgeDuplicateTime : float = 0.05 # determines when ghosts spawn after dodging
var currentDodgeDuplicateTime : float = 0
@export var duplicateLifeTime : float = 0.3 # determines how long ghosts are alive for
var isDodging : bool = false
@export var dodgeTransparency : float = 0.7 # determines ghost transparency

const acceleration = 800
const friction = 500
const maxSpeed = 120

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]
@onready var gun = $gun
@onready var sword = $sword

enum {idle, run}
var state = idle

enum weaponState {melee, ranged}
var currentWeaponState = weaponState.ranged

var blendPosition : Vector2 = Vector2.ZERO
var blendPosPaths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/run/run_bs2d/blend_position"
]
var animTreeStateKeys = [
	"idle",
	"run"
]

func _ready():
	# sets sword default behaviour
	sword.hide()
	sword.set_process(false)

func _physics_process(delta):
	move(delta)
	animate()

func _process(_delta: float) -> void:
	# checks weaponState to switch between weapons
	if Input.is_action_just_pressed("weaponSwitch"):
		if currentWeaponState == weaponState.melee:
			print("switching to ranged!")
			gun.show()
			gun.set_process(true)
			sword.hide()
			sword.set_process(false)
			currentWeaponState = weaponState.ranged
		elif currentWeaponState == weaponState.ranged:
			print("switching to melee!")
			gun.hide()
			gun.set_process(false)
			sword.show()
			sword.set_process(true)
			currentWeaponState = weaponState.melee

	# DEBUG heal
	if Input.is_action_just_pressed("DEBUGHEAL"):
		heal(3)

	# checks deflectedProjectiles and calls heal when reaching 5
	if game.deflectedProjectiles == 5:
		heal(1)
		game.deflectedProjectiles = 0

	if game.playerHP == 0:
		queue_free()

func move(delta):
	# takes input to move
	var inputVector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	if inputVector == Vector2.ZERO and !isDodging:
		state = idle
		applyFriction(friction * delta)
	else:
		if isDodging:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = lerp(velocity.y, 0.0, 0.1)
		else:
			state = run
			applyMovement(inputVector * acceleration * delta)
			blendPosition = inputVector

	# takes currentDodgeTime to limit dodge length, also checks when to spawn dodge ghosts
	if isDodging:
		currentDodgeTime += delta
		currentDodgeDuplicateTime += delta
		if currentDodgeTime >= dodgeTime:
			currentDodgeDuplicateTime = 0.0
			currentDodgeTime = 0.0
			isDodging = false
		if currentDodgeDuplicateTime >= dodgeDuplicateTime:
			currentDodgeDuplicateTime = 0.0
			createDuplicate()

	# checks for key press to dodge
	if isDodging == false && Input.is_action_just_pressed("moveDodge"):
		isDodging = true
		velocity = dodgeSpeed * inputVector
		createDuplicate()

	move_and_slide()

func applyFriction(amount) -> void:
	# takes amount to calculate friction
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func applyMovement(amount) -> void:
	# takes amount and turns into movement (velocity)
	velocity += amount
	velocity = velocity.limit_length(maxSpeed)

func animate() -> void:
	# get called to change AnimatedSprite2D's current animation
	stateMachine.travel(animTreeStateKeys[state])
	animationTree.set(blendPosPaths[state], blendPosition)

func createDuplicate():
	# created 'dodge shadows'
	@warning_ignore("SHADOWED_VARIABLE_BASE_CLASS")
	var duplicate = $AnimatedSprite2D.duplicate(true)
	duplicate.material = $AnimatedSprite2D.material.duplicate(true)
	duplicate.material.set_shader_parameter("opacity", dodgeTransparency)
	duplicate.material.set_shader_parameter("r", 0.0)
	duplicate.material.set_shader_parameter("g", 0.0)
	duplicate.material.set_shader_parameter("b", 0.8)
	duplicate.material.set_shader_parameter("mix_color", 0.6)
	duplicate.position.y += position.y
	duplicate.position.x += position.x
	duplicate.z_index -= 1
	get_parent().add_child(duplicate)
	await get_tree().create_timer(duplicateLifeTime).timeout
	duplicate.queue_free()

func heal(healAmount):
	# updates PlayerHP based on current HP
	if game.playerHP < 3:
		game.playerHP += healAmount
		if game.playerHP > 3:
			game.playerHP = 3
		print("Healed! Current player HP: ", game.playerHP)
	else:
		print("You cannot heal at this moment.")