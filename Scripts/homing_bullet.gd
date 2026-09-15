extends Bullet


var bool_parry: bool = false


func _ready() -> void:
	speed = 200

func _physics_process(delta: float) -> void:
	if bool_parry:
		look_at(enemy.global_position)
	else:
		look_at(player.global_position)
	move_local_x(speed * delta)

#func _new_player_position():
	#_enemy_target_position = _enemy_start_position + Vector2(randi() % 300, randi() % 200)

func parry():
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	bool_parry = true
	speed = 400
	print("PARRY")
