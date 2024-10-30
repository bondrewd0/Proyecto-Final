extends ColorRect


signal  unpause

func _on_continue_pressed():
	hide()
	get_tree().paused=false
	unpause.emit()


func _on_exit_pressed():
	get_tree().quit()
