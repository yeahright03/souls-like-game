extends Node2D

const bullet = preload("res://player/bullet.tscn")

@onready var gunMuzzle : Marker2D = $Marker2D

func _process(_delta: float) -> void:
    # takes mouse input to aim gun
    look_at(get_global_mouse_position())

    # flip sprite based on angle
    rotation_degrees = wrap(rotation_degrees, 0, 360)
    if rotation_degrees > 90 and rotation_degrees < 270:
        scale.y = -1
    else:
        scale.y = 1

    # shoots a bullet when being pressed with rotation being based on angle
    if Input.is_action_just_pressed("playerAttack"):
        var bulletInstance = bullet.instantiate()
        get_tree().root.add_child(bulletInstance)
        bulletInstance.global_position = gunMuzzle.global_position
        bulletInstance.rotation = rotation

