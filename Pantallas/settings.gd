extends ColorRect

signal soundV_Changed(new_value:float)
signal musicV_Changed(new_value:float)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sound_volume_value_changed(value):
	soundV_Changed.emit(value)


func _on_return_pressed():
	hide()


func _on_music_volume_value_changed(value):
	musicV_Changed.emit(value)
