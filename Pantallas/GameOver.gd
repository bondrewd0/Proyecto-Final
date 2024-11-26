extends ColorRect


# Called when the node enters the scene tree for the first time.
#func _ready():
	#$AnimationPlayer.play("appear")

func play_anim():
	$Reintentar.disabled=false
	$AnimationPlayer.play("appear")

func _on_salir_pressed():
	print("Exit")
	get_tree().quit()


func _on_reintentar_pressed():
	print("retry")
	$Reintentar.disabled=true
	SignalBus.reset_game.emit()
	
func _input(event):
	if event.is_action_pressed("Testeo"):
		hide()
