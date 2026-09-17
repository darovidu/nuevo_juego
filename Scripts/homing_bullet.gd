extends Bullet


var bool_parry: bool = false


func _ready() -> void:
	speed = 200

func _physics_process(delta: float) -> void:
	if !boolDestroy:
		if bool_parry:
			look_at(enemy.global_position)
		else:
			look_at(player.global_position)
		move_local_x(speed * delta)

func parry():
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	bool_parry = true
	speed = 400
	print("PARRY")
