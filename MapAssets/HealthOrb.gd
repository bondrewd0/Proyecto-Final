extends Sprite2D


func _on_area_2d_area_entered(area):
	var parent=area.get_parent()
	if parent is Player:
		parent.health_component.heal()
		queue_free()