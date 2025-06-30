extends CharacterBody2D

const acceleration = 800
const friction = 500
const maxSpeed = 120

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]
@onready var gun = $gun
@onready var spear = $spear

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
	spear.visible = false
	spear.set_process(false)

func _physics_process(delta):
	move(delta)
	animate()

func _process(_delta: float) -> void:
	# checks weaponState to switch between weapons
	if Input.is_action_just_pressed("weaponSwitch"):
		if currentWeaponState == weaponState.melee:
			print("switching to ranged!")
			gun.visible = true
			gun.set_process(true)
			spear.visible = false
			spear.set_process(false)
			currentWeaponState = weaponState.ranged
		elif currentWeaponState == weaponState.ranged:
			print("switching to melee!")
			gun.visible = false
			gun.set_process(false)
			spear.visible = true
			spear.set_process(true)
			currentWeaponState = weaponState.melee

func move(delta):
	# takes input to move
	var inputVector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	if inputVector == Vector2.ZERO:
		state = idle
		applyFriction(friction * delta)
	else:
		state = run
		applyMovement(inputVector * acceleration * delta)
		blendPosition = inputVector
	move_and_slide()

func applyFriction(amount) -> void:
	# takes amount to calculate friction
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func applyMovement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(maxSpeed)

func animate() -> void:
	stateMachine.travel(animTreeStateKeys[state])
	animationTree.set(blendPosPaths[state], blendPosition)
