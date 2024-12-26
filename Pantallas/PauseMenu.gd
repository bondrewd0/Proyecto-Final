extends ColorRect


signal  unpause
signal open_settings
func _on_continue_pressed():
	hide()
	get_tree().paused=false
	unpause.emit()


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	open_settings.emit()


func _on_visibility_changed():
	if visible:
		$Continue.grab_focus()
