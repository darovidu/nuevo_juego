extends Weapon


@onready var BULLET = preload("res://Scenes/bullet.tscn")
@onready var tween: Tween = null

var finish_hold: bool = false
var duration: float = 0.5
var big_shot: bool = false


func shoot():
	if canShoot:
		canShoot = false
		var bullet = BULLET.instantiate()
		bullet.global_position = $Marker2D.global_position
		bullet.global_rotation = self.global_rotation
		if big_shot:
			bullet.big_shot = true
			big_shot = false
		get_parent().get_parent().get_parent().add_child(bullet)
		$Animations.play("shoot")
		$AnimationsEffects.play("shot")

func hold_shoot():
	if canShoot:
		if tween:
			tween.kill()
		$SpritesEffects.animation = "hold_shoot"
		$SpritesEffects.scale = Vector2(0.0, 0.0)
		$SpritesEffects.visible = true
		tween = create_tween()
		tween.tween_property($SpritesEffects, "scale", Vector2(1.0, 1.0), duration)
		tween.tween_property($SpritesEffects, "frame", 1, 0)
		await tween.finished
		finish_hold = true
		tween.kill()

func release_shoot():
	if tween:
		tween.kill()
	if finish_hold:
		big_shot = true
		finish_hold = false
		shoot()
	else:
		canShoot = false
		tween = create_tween()
		tween.tween_property($SpritesEffects, "scale", Vector2(0.0, 0.0), duration)
		await tween.finished
		canShoot = true
		tween.kill()
