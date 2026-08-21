extends Area2D

var direction = Vector2.ZERO
var speed = 500

func _physics_process(delta: float) -> void:
	move_local_x(speed * delta)
