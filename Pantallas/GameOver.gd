extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("appear")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_salir_pressed():
	print("Exit")
	get_tree().quit()


func _on_reintentar_pressed():
	print("retry")
	get_tree().reload_current_scene()
