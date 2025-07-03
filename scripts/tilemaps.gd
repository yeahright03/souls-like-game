extends Node2D

@onready var walls = $walls
@onready var traversal = $traversal

func _on_tunnel_area_body_entered(body:Node2D) -> void:
	if body.name == "player":
		print("disabled")
		traversal.collision_enabled = false

func _on_tunnel_area_body_exited(body:Node2D) -> void:
	if body.name == "player":
		print("enabled")
		traversal.collision_enabled = true

func _on_test_body_entered(body:Node2D) -> void:
	print("bingus")
	if body.name == "player":
		print("spawned")