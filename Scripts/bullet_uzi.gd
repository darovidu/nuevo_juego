extends Bullet


@export var explosion_damage:int = 0


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit") and body == enemy:
		body.hit(damage)
	speed = 0
	$Animations.play("destroy")

func explosion():
	$Animations.play("explosion")

func _on_explosion_body_entered(body: Node2D) -> void:
	if body.has_method("hit") and body == enemy:
		body.hit(explosion_damage)
