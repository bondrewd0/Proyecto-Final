extends Node2D

signal begin_game
func _on_play_pressed():
	begin_game.emit()
	get_parent().remove_child(self)
	queue_free()


func _on_exit_pressed():
	get_tree().quit()
