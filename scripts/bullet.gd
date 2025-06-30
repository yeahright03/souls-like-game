extends Node2D

var uselessTimer : float = 0.05 # time until bullet becomes active
var wasDeflected : bool = false # checks if it is a normal or critical hit
const speed : int = 300

func _process(delta: float) -> void:
	# gives bullet speed
	position += transform.x.normalized() * speed * delta

	# makes bullet unable to do anything until the timer runs out
	if uselessTimer >= 0.0:
		uselessTimer -= delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# removes bullet when outside of camera
	queue_free()

func _on_bullet_hit_body_entered(body:Node2D) -> void:
	# checks for bullet timer
	if uselessTimer <= 0.0:
		# prints when enemy is registering hits
		if body.name == "generic enemy":
			if wasDeflected:
				print("CRIT HIT!")
			else:
				print("HIT!")
			queue_free()

func _on_bullet_hit_area_entered(area:Area2D) -> void:
	# takes area and checks for deflect or player hit
	var sword = area.get_parent()
	if area.name == "meleeSwingArea":
		if sword.swinging:
			print("deflect with swing")
			rotation_degrees += 180
			wasDeflected = true
	if area.name == "playerHitBox":
		var player = area.get_parent()
		if player.isDodging:
			print("DODGED!")
		else:
			print("PLAYER HIT!")
			queue_free()
