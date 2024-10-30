extends ColorRect

@export var First_level:PackedScene

func _on_play_pressed():
	SignalBus.pass_level.emit(First_level)


func _on_exit_pressed():
	get_tree().quit()
