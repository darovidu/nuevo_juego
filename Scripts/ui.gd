extends CanvasLayer




func _on_player_hurt(health: int) -> void:
	$PanelContainer/TextureProgressBar.value = health
