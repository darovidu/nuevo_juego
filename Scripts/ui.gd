extends CanvasLayer


var health: int = 100


func _ready() -> void:
	$PanelContainer/ProgressBar.value = health
	$PanelContainer/Label.text = str(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
