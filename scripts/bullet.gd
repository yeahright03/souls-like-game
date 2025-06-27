extends Node2D

const speed : int = 300

func _process(delta: float) -> void:
	position += transform.x.normalized() * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_bullet_hit_body_entered(body:Node2D) -> void:
	if body.name == "generic enemy":
		print("HIT!")
		queue_free()
