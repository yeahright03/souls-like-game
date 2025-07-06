extends Node2D

var swinging : bool = false
var alreadyHitTargets : Array = []
var lastRotation : float = 0
var swingTimer : float = 0
@export var followSpeed : float = 25 # lower = heavier
var desiredRotation : float = 0
const swingDuration : float = 0.3
@export var minRotationSpeed : int = 700 # lower = easier to swing

func _process(delta: float) -> void:
	# takes mouse position to aim sword
	desiredRotation = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, desiredRotation, delta * followSpeed)

	# flip sprite based on angle
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

	var rotationSpeed : float = abs(rotation_degrees - lastRotation) / delta

	# takes rotation speed and checks if to return swining, clears already hit targets
	if rotationSpeed > minRotationSpeed and not swinging:
		swinging = true
		swingTimer = swingDuration
		alreadyHitTargets.clear()
		print("swing!!")

	# limits how long swing lasts
	if swinging:
		swingTimer -= delta
		if swingTimer <= 0:
			swinging = false
			swingTimer = 0.0
			
	lastRotation = rotation_degrees

func _on_melee_swing_area_body_entered(body:Node2D) -> void:
	# checks if body was hit or not
	if swinging and body.is_in_group("enemies"):
		#var swingSpeed : float = abs(rotation_degrees - lastRotation)
		#var damage : float = clamp(swingSpeed / 10, 1, 10)
		#print("Hit ", body.name, " for ", damage, " damage!!")
		print("Swung hit, 5 DMG!")
		body.health -= 5
		alreadyHitTargets.append(body)
		