extends CharacterBody2D

const acceleration = 800
const friction = 500
const maxSpeed = 120

enum {idle, run}
var state = idle

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]

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

func move(delta):
    var inputVector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
