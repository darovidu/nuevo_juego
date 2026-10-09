extends CharacterBody2D


@onready var BULLET = preload("res://Scenes/bullet.tscn")

@export var weapon:int = 0

var direction:Vector2 = Vector2.ZERO
var canShoot:bool = true
var dashVelocity:int = 400
var last_direction = "down"
var health:int = 3
var speed:int = 200

signal hurt(health:int)

enum STATE {
	IDLE,
	RUN,
	ATTACK,
	DASH,
	HURT,
	DIE
}

var current_State:STATE = STATE.IDLE


func get_Current_State():
	return current_State

func _input(event: InputEvent) -> void:
	if current_State != STATE.DIE:
		if event.is_action_pressed("right") or event.is_action_pressed("left") or event.is_action_pressed("up") or event.is_action_pressed("down"):
			if current_State != STATE.DASH:
				current_State = STATE.RUN
		
		if Input.is_action_just_pressed("click") and canShoot:
			shoot()
		
		if Input.is_action_just_pressed("dash") and current_State == STATE.RUN and direction != Vector2.ZERO:
			$Dash.start()
			current_State = STATE.DASH
		
		if Input.is_action_just_pressed("parry"):
			parry()
		
		if Input.is_action_just_pressed("revolver") and weapon != 1:
			change_weapon(1)
		elif Input.is_action_just_pressed("shotgun") and weapon != 2:
			change_weapon(2)

func _physics_process(delta: float) -> void:
	$Weapon.look_at(get_global_mouse_position())
	$Parry.look_at(get_global_mouse_position())
	
	if $Weapon/Revolver.global_rotation_degrees > 90.0 or $Weapon/Revolver.global_rotation_degrees < -90.0:
		$Weapon/Revolver.flip(true)
	else:
		$Weapon/Revolver.flip(false)
	
	match current_State:
		
		STATE.IDLE:
			if last_direction == "right":
				$Animations.play("idle_right")
			elif last_direction == "left":
				$Animations.play("idle_left")
			elif last_direction == "down":
				$Animations.play("idle_down")
			elif last_direction == "up":
				$Animations.play("idle_up")
			
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
		
		STATE.RUN:
			direction = Input.get_vector("left", "right", "up", "down").normalized()
			velocity = direction * speed
			
			if direction == Vector2.ZERO:
				current_State = STATE.IDLE
			else:
				if abs(velocity.x) > abs(velocity.y):
					if velocity.x > 0:
						$Animations.play("walk_right")
						last_direction = "right"
					else:
						$Animations.play("walk_left")
						last_direction = "left"
				else:
					if velocity.y > 0:
						$Animations.play("walk_down")
						last_direction = "down"
					else:
						$Animations.play("walk_up")
						last_direction = "up"
		
		STATE.DASH:
			set_collision_mask_value(4, false)
			if last_direction == "right":
				$Animations.play("dash_right")
			elif last_direction == "left":
				$Animations.play("dash_left")
			elif last_direction == "down":
				$Animations.play("dash_down")
			elif last_direction == "up":
				$Animations.play("dash_up")
			
			velocity = dashVelocity * direction
			
		STATE.DIE:
			$Animations.play("die")
		
	if current_State != STATE.DIE:
		move_and_slide()

func _on_cooldown_shoot_timeout() -> void:
	canShoot = true

func _on_dash_timeout() -> void:
	velocity = Vector2.ZERO
	set_collision_mask_value(4, true)
	if direction == Vector2.ZERO:
		current_State = STATE.IDLE
	else:
		current_State = STATE.RUN

func hit():
	if current_State != STATE.DASH:
		health -= 1
		hurt.emit(health)
		if health <= 0:
			current_State = STATE.DIE
		else:
			current_State = STATE.HURT

func parry():
	$Parry/HitBoxParry.disabled = false
	$ParryTimer.start()

func _on_parry_timer_timeout() -> void:
	$Parry/HitBoxParry.disabled = true

func _on_parry_area_entered(area: Area2D) -> void:
	if area.has_method("parry") and area.is_in_group("enemy_Bullet"):
		area.global_rotation = $Parry.global_rotation
		area.parry()

func _on_parry_body_entered(body: Node2D) -> void:
	if body.get_tree().get_first_node_in_group("enemy") and body.has_method("hit"):
		body.hit()

func shoot():
	match weapon:
		1:
			$Weapon/Revolver.shoot()
		2:
			pass

func change_weapon(num_weapon:int):
	match num_weapon:
		1:
			$Weapon/Revolver.visible = true
			$Weapon/Sniper.visible = false
			weapon = 1
		2:
			$Weapon/Revolver.visible = false
			$Weapon/Sniper.visible = true
			weapon = 2
