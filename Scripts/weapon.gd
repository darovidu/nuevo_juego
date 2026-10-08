extends Node2D

@export var cooldown: float = 0.0

@onready var BULLET = preload("res://Scenes/bullet.tscn")

var canShoot: bool = true


func _on_player_shoot() -> void:
	canShoot = false
	var bullet = BULLET.instantiate()
	bullet.global_position = $Marker2D.global_position
	bullet.global_rotation = self.global_rotation
	get_parent().add_child(bullet)
	$Animations.play("shoot")

func flip(value:bool):
	if value:
		$Sprites.flip_v = true
	else:
		$Sprites.flip_v = false
