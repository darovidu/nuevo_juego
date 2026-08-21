extends CharacterBody2D


const SPEED = 300.0

@onready var marker: Marker2D = $Marker2D
@onready var BULLET = preload("res://Scenes/bullet.tscn")

var direction = Vector2.ZERO
var canShoot = true
var dashVelocity:int = 600

enum STATE {
	IDLE,
	RUN,
	ATTACK,
	DASH
}

var current_State:STATE = STATE.IDLE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right") or event.is_action_pressed("left") or event.is_action_pressed("up") or event.is_action_pressed("down"):
		if current_State != STATE.DASH:
			current_State = STATE.RUN
	
	if event.is_action_released("right") and event.is_action_released("left") and event.is_action_released("up") and event.is_action_released("down"):
		current_State = STATE.IDLE
	
	if Input.is_action_just_pressed("click"):
		shoot()
	
	if Input.is_action_just_pressed("dash") and current_State == STATE.RUN:
		$Dash.start()
		current_State = STATE.DASH

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	match current_State:
		
		STATE.IDLE:
			#if direction.x == 1:
				#$Animations.play("idle_right")
			#elif direction.x == -1:
				#$Animations.play("idle_left")
			#if direction.y == 1:
				#$Animations.play("idle_down")
			#elif direction.y == -1:
				#$Animations.play("idle_up")
			
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
		STATE.RUN:
			direction = Input.get_vector("left", "right", "up", "down").normalized()
			
			#if direction.x == 1:
				#$Animations.play("walk_right")
			#elif direction.x == -1:
				#$Animations.play("walk_left")
			#if direction.y == 1:
				#$Animations.play("walk_down")
			#elif direction.y == -1:
				#$Animations.play("walk_up")
			
			velocity = direction * SPEED
		
		STATE.DASH:
			velocity = dashVelocity * direction
		
	move_and_slide()

func shoot():
	canShoot = false
	var bullet = BULLET.instantiate()
	bullet.global_position = marker.global_position
	bullet.global_rotation = global_rotation
	get_parent().add_child(bullet)
	$CooldownShoot.start()

func _on_cooldown_shoot_timeout() -> void:
	canShoot = true

func _on_dash_timeout() -> void:
	velocity = Vector2.ZERO
	if direction == Vector2.ZERO:
		current_State = STATE.IDLE
	else:
		current_State = STATE.RUN
