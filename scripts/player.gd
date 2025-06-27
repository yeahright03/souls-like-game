extends CharacterBody2D

const acceleration = 800
const friction = 500
const maxSpeed = 120

enum {idle, run}
var state = idle

enum weaponState {melee, ranged}
var currentWeaponState = weaponState.ranged

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]
@onready var gun = $gun

var blendPosition : Vector2 = Vector2.ZERO
var blendPosPaths = [
    "parameters/idle/idle_bs2d/blend_position",
    "parameters/run/run_bs2d/blend_position"
]
var animTreeStateKeys = [
    "idle",
    "run"
]

func _physics_process(delta):
    move(delta)
    animate()

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("weaponSwitch"):
        if currentWeaponState == weaponState.melee:
            print("switching to ranged!")
            gun.visible = true
            gun.set_process(true)
            #melee.visible = false
            #melee.set_process(false)
            currentWeaponState = weaponState.ranged
        elif currentWeaponState == weaponState.ranged:
            print("switching to melee!")
            gun.visible = false
            gun.set_process(false)
            #melee.visible = true
            #melee.set_process(true)
            currentWeaponState = weaponState.melee

func move(delta):
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
