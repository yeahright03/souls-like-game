extends Node2D

@onready var pauseMenuNode = $pauseMenu
#var paused : bool = false
#
#func _process(delta: float) -> void:
#    if Input.is_action_just_pressed("pause"):
#        pauseMenu()
#
#
#func pauseMenu():
#    if paused:
#        pauseMenuNode.hide()
#        get_tree().paused = false
#    else:
#        pauseMenuNode.show()
#        get_tree().paused = true
#
#    paused = !paused