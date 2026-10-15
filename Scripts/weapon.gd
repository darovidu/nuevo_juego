class_name Weapon extends Node


@export var cooldown: float = 0.0
@export var canShoot: bool = true

func flip(value:bool):
	if value:
		$Sprites.flip_v = true
		$SpritesEffects.position.y = 2.0
		$Marker2D.position.y = 2.333
	else:
		$Sprites.flip_v = false
		$SpritesEffects.position.y = -3.0
		$Marker2D.position.y = -2.667
