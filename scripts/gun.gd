extends Node2D

const bullet = preload("res://player/bullet.tscn")
@onready var shootAnimation = $AnimationPlayer
@onready var bulletShotSound = $bulletShot
var timeSinceShot : float = 0.125

@onready var gunMuzzle : Marker2D = $Marker2D

func _process(delta: float) -> void:
    # takes mouse input to aim gun
    look_at(get_global_mouse_position())

    # counts time since last shot
    timeSinceShot += delta

    # flip sprite based on angle
    rotation_degrees = wrap(rotation_degrees, 0, 360)
    if rotation_degrees > 90 and rotation_degrees < 270:
        scale.y = -1
    else:
        scale.y = 1

    # shoots a bullet when being pressed with rotation being based on angle
    if Input.is_action_just_pressed("playerAttack") and timeSinceShot >= 0.125:
        shootAnimation.play("shoot")
        bulletShotSound.play()
        timeSinceShot = 0
        await get_tree().create_timer(0.05).timeout
        var bulletInstance = bullet.instantiate()
        get_tree().root.add_child(bulletInstance)
        bulletInstance.global_position = gunMuzzle.global_position
        bulletInstance.rotation = rotation
