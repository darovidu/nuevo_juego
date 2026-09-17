extends RayCast2D

@export var max_length = 1000
@export var speed = 300

var can_shoot: bool = false


func _physics_process(delta: float) -> void:
	if is_colliding():
		var collision_point = get_collision_point()
		print("collision")
	elif can_shoot:
		target_position.x = move_toward(target_position.x, max_length, speed * delta)

func shoot():
	can_shoot = true
