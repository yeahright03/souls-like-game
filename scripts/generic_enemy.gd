extends CharacterBody2D

const projectile = preload("res://player/spearProjectile.tscn")
var playerSpotted : bool = false # checks for player
var timeSinceShot : float = 1 # larger = longer time between shots

func _process(delta: float) -> void:
	# takes playerSpotted and begin shooting at player based on enemy angle
	if playerSpotted == true:
		look_at(get_node("../player/playerHitBox").global_position)
		if timeSinceShot >= 1:
			print("pew!!")
			var projectileInstance = projectile.instantiate()
			get_tree().root.add_child(projectileInstance)
			projectileInstance.global_position = position
			projectileInstance.rotation = rotation
			timeSinceShot = 0.0
	else:
		self.rotation = 0

	# makes sure the enemy doesn't go rapid fire
	if timeSinceShot < 1:
		timeSinceShot += delta

func _on_player_detection_body_entered(body: Node2D) -> void:
	# returns playerSpotted when player enters detection range
	if body.name == "player":
		print("player spotted")
		playerSpotted = true

func _on_player_detection_body_exited(body:Node2D) -> void:
	# returns playerSpotted to false when player exits detection range
	if body.name == "player":
		print("i lost the player")
		playerSpotted = false
