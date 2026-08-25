extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var PLAYER = get_tree().get_first_node_in_group("player")
@onready var BULLET = preload("res://Scenes/enemyBullet.tscn")

var attack:bool = false
var canShoot:bool = true


func _physics_process(delta: float) -> void:
	if attack:
		look_at(PLAYER.global_position)
		if canShoot:
			shoot()
	move_and_slide()

func shoot():
	canShoot = false
	var bullet = BULLET.instantiate()
	bullet.global_position = $Marker.global_position
	bullet.global_rotation = global_rotation
	get_parent().add_child(bullet)
	$CooldownShoot.start()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == PLAYER:
		attack = true

func _on_cooldown_shoot_timeout() -> void:
	canShoot = true

func hit():
	queue_free()
