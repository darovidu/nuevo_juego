class_name Bullet extends Area2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var enemy: CharacterBody2D = get_tree().get_first_node_in_group("enemy")

var speed:int = 500


func _physics_process(delta: float) -> void:
	move_local_x(speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		if (body == player and body.has_method("get_Current_State") and body.get_Current_State() != 3) or (body == enemy):
			body.hit()
			queue_free()
	else:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func parry():
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	speed = 400
	print("PARRY")
