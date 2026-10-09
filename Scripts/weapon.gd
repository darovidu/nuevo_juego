class_name Weapon extends Node


@export var cooldown: float = 0.0
@export var canShoot: bool = true

func flip(value:bool):
	if value:
		$Sprites.flip_v = true
	else:
		$Sprites.flip_v = false
