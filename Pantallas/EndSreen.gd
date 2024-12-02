extends ColorRect


signal bact_to_menu
func _on_menu_pressed():
	bact_to_menu.emit()


func _on_salir_pressed():
	get_tree().quit()
