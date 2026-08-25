class_name Bullet extends Area2D


var speed:int = 500

func _physics_process(delta: float) -> void:
	move_local_x(speed * delta)

func _on_body_entered(body: Node2D) -> void:
	body.hit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func parry():
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	print("PARRY")
