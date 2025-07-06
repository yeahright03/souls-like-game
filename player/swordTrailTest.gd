extends Line2D

var queue : Array = []
@export var maxLength : int = 20
@onready var sword = get_parent().get_parent()

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	var originPos = get_parent().global_position

	# shows and hides trail when sword is not equipped
	if Input.is_action_just_pressed("weaponSwitch") and !visible:
		show()
	elif Input.is_action_just_pressed("weaponSwitch") and visible:
		hide()

	queue.push_front(originPos)

	if queue.size() > maxLength:
		queue.pop_back()

	clear_points()
	
	if sword.swinging:
		for point in queue:
			add_point(point)
