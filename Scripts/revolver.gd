extends Weapon


@onready var BULLET = preload("res://Scenes/bullet.tscn")


func shoot():
	if canShoot:
		canShoot = false
		var bullet = BULLET.instantiate()
		bullet.global_position = $Marker2D.global_position
		bullet.global_rotation = self.global_rotation
		get_parent().get_parent().get_parent().add_child(bullet)
		$Animations.play("shoot")
		$AnimationsEffects.play("shot")
