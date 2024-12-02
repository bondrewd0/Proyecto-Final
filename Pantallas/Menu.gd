extends Node2D

signal begin_game
func _on_play_pressed():
	begin_game.emit()
	hide()


func _on_exit_pressed():
	get_tree().quit()
