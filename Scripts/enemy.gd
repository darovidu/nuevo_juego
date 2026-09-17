extends CharacterBody2D


const SPEED = 100.0

@onready var PLAYER: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var BULLET = preload("res://Scenes/enemyBullet.tscn")
@onready var HOMINGBULLET = preload("res://Scenes/homing_bullet.tscn")

var attack:bool = false
var canShoot:bool = true
var direction:Vector2 = Vector2.ZERO

enum STATE {
	IDLE,
	RUN,
	DIE
}

var current_State:STATE = STATE.IDLE


func _physics_process(delta: float) -> void:
	$Weapon.look_at(PLAYER.global_position)
	
	match current_State:
		STATE.IDLE:
			if attack:
				current_State = STATE.RUN
			direction = Vector2.ZERO
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
				
		STATE.RUN:
			if attack == false:
				current_State = STATE.IDLE
			direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			velocity = direction * SPEED
			
			if abs(velocity.x) > abs(velocity.y):
				if velocity.x > 0:
					$Animations.play("idle_right")
				#else:
					#$Sprites.flip_h = true
			else:
				if velocity.y > 0:
					$Animations.play("idle_down")
				else:
					$Animations.play("idle_up")
			
			if canShoot:
				shoot()
			
		STATE.DIE:
			print("death")
			queue_free()
	move_and_slide()

func shoot():
	canShoot = false
	var bullet = HOMINGBULLET.instantiate()
	bullet.global_position = $Weapon/Marker.global_position
	bullet.global_rotation = $Weapon.global_rotation
	get_parent().add_child(bullet)
	$CooldownShoot.start()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == PLAYER:
		$DetectionTimer.stop()
		attack = true

func _on_cooldown_shoot_timeout() -> void:
	canShoot = true

func hit():
	current_State = STATE.DIE

func _on_navigation_timer_timeout() -> void:
	if current_State == STATE.RUN:
		$NavigationAgent2D.target_position = PLAYER.global_position

func _on_detection_timer_timeout() -> void:
	attack = false

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == PLAYER:
		$DetectionTimer.start()
