extends Node2D

const speed : int = 300

func _process(delta: float) -> void:
	# gives bullet speed
	position += transform.x.normalized() * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# removes bullet when outside of camera
	queue_free()

func _on_bullet_hit_body_entered(body:Node2D) -> void:
	# prints when enemy is registering hits
	if body.name == "generic enemy":
		print("HIT!")
		queue_free()
