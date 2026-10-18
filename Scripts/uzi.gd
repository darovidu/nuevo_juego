extends Node2D

@onready var BULLET_UZI = preload("res://Scenes/bullet_uzi.tscn")

@export var can_shoot: bool = true


#func _physics_process(delta: float) -> void:
	#print(global_rotation)

func shoot():
	if can_shoot:
		can_shoot = false
		var bullet_rotation = randf_range(self.global_rotation - 0.15, self.global_rotation + 0.15)
		var bullet = BULLET_UZI.instantiate()
		bullet.global_position = $Marker2D.global_position
		bullet.global_rotation = bullet_rotation
		get_parent().get_parent().get_parent().add_child(bullet)
		$Animations.play("shoot")

func secundary_shoot():
	get_tree().call_group("bullet_uzi", "explosion")
