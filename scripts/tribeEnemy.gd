extends CharacterBody2D

const projectile = preload("res://player/spearProjectile.tscn")
@onready var spearWeapon = $spearWeapon
var playerSpotted : bool = false # checks for player
var timeSinceShot : float = 1 # larger = longer time between shots
var health = 10

func _ready() -> void:
	spearWeapon.hide()
	add_to_group("enemies")

func _process(delta: float) -> void:
	# takes playerSpotted and begin shooting at player based on enemy angle
	if playerSpotted == true:
		spearWeapon.look_at(get_tree().current_scene.get_node("player").position)
		if timeSinceShot >= 1:
			timeSinceShot = 0.0
			spearWeapon.show()
			await get_tree().create_timer(0.4).timeout
			spearWeapon.hide()
			print("Throw!!")
			var projectileInstance = projectile.instantiate()
			get_tree().root.add_child(projectileInstance)
			projectileInstance.global_position = spearWeapon.global_position
			projectileInstance.rotation = spearWeapon.rotation
	else:
		self.rotation = 0

	# makes sure the enemy doesn't go rapid fire
	if timeSinceShot < 1:
		timeSinceShot += delta

	if health <= 0:
		queue_free()

func _on_player_detection_body_entered(body: Node2D) -> void:
	# returns playerSpotted when player enters detection range
	if body.name == "player":
		print("Player spotted")
		playerSpotted = true

func _on_player_detection_body_exited(body:Node2D) -> void:
	# returns playerSpotted to false when player exits detection range
	if body.name == "player":
		print("Player lost")
		playerSpotted = false
