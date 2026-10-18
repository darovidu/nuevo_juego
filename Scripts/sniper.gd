extends Weapon



func shoot():
	if canShoot:
		canShoot = false
		$Animations.play("shoot")
		$Laser.set_is_casting(true)

func _on_cooldown_shoot_timeout() -> void:
	canShoot = true
	print("READY!")

func _on_laser_finish_laser() -> void:
	$CooldownShoot.start()
