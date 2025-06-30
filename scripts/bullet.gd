extends Node2D

var uselessTimer : float = 0.05
var wasDeflected : bool = false
const speed : int = 300

func _process(delta: float) -> void:
	# gives bullet speed
	position += transform.x.normalized() * speed * delta

	if uselessTimer >= 0.0:
		uselessTimer -= delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# removes bullet when outside of camera
	queue_free()

func _on_bullet_hit_body_entered(body:Node2D) -> void:
	if uselessTimer <= 0.0:
		# prints when enemy is registering hits
		if body.name == "generic enemy":
			if wasDeflected:
				print("CRIT HIT!")
			else:
				print("HIT!")
			queue_free()
#		if body.name == "player":
#			var player = body
#			if player.isDodging:
#				print("dodge")
#			else:
#				print("player hit!")
#				queue_free()

func _on_bullet_hit_area_entered(area:Area2D) -> void:
	var spear = area.get_parent()
	if area.name == "meleeSwingArea":
		if spear.swinging:
			print("deflect with swing")
			rotation_degrees += 180
			wasDeflected = true
