extends Node2D

signal begin_game
signal open_settings
func _on_play_pressed():
	begin_game.emit()
	hide()


func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	open_settings.emit()
