extends RayCast2D

@export var max_length = 1000
@export var speed = 300
@export var is_casting: bool = false
@export var growth_time: float = 0.1
@export var line_width: float = 10.0

var tween: Tween = null

func _ready() -> void:
	set_is_casting(is_casting)
	$Line2D.set_point_position(0, Vector2.ZERO)
	$Line2D.set_point_position(1, Vector2.ZERO)
	$Line2D.visible = false

func _physics_process(delta: float) -> void:
	if is_casting:
		target_position.x = move_toward(target_position.x, max_length, speed * delta)
		
		force_raycast_update()
		
		if is_colliding():
			$Line2D.set_point_position(1, to_local(get_collision_point()))
		else:
			$Line2D.set_point_position(1, target_position)

func set_is_casting(new_value):
	if is_casting == new_value:
		return
	is_casting = new_value
	
	if is_casting == false:
		target_position = Vector2.ZERO
		$Line2D.set_point_position(0, Vector2.ZERO)
		$Line2D.set_point_position(1, Vector2.ZERO)
	else:
		print("appear")
		target_position = Vector2.ZERO
		$Line2D.set_point_position(0, Vector2.ZERO)
		$Line2D.set_point_position(1, Vector2.ZERO)
		appear()

func appear():
	$Line2D.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", line_width, growth_time * 2.0).from(0.0)
	tween.tween_callback($Timer.start)

func disappear():
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0.0, growth_time * 2.0).from_current()
	tween.tween_property($Line2D, "visible", false, 0)
	await tween.finished
	set_is_casting(false)

func _on_timer_timeout() -> void:
	disappear()
