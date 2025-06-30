extends CharacterBody2D

const bullet = preload("res://player/bullet.tscn")
#var player
var playerSpotted : bool = false
var timeSinceShot : float = 1

func _process(delta: float) -> void:
	if playerSpotted == true:
		look_at(get_node("../player/playerHitBox").global_position)
		print(get_node("../player/playerHitBox").global_position)
		if timeSinceShot >= 1:
			print("pew!!")
			var bulletInstance = bullet.instantiate()
			get_tree().root.add_child(bulletInstance)
			bulletInstance.global_position = position
			bulletInstance.rotation = rotation
			timeSinceShot = 0.0
	else:
		self.rotation = 0

	if timeSinceShot < 1:
		timeSinceShot += delta

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("player spotted")
		playerSpotted = true

func _on_player_detection_body_exited(body:Node2D) -> void:
	if body.name == "player":
		print("i lost the player")
		playerSpotted = false
