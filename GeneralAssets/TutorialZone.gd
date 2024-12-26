extends ColorRect

@onready var tutorial = $Tutorial2
@export var Message:String
@onready var enter_sfx = $EnterSFX
@onready var exit_sfx = $ExitSFX


func _ready():
	tutorial.size=size
	tutorial.Tutorial_text.size=size
	tutorial.screen.size=size
	tutorial.effect.size=size
	self_modulate=Color(1,1,1,0)
	tutorial.Tutorial_text.text="[b][center]"+Message


func _on_tutorial_area_entered(_area):
	for child in get_children():
		child.show()
		enter_sfx.play()


func _on_tutorial_area_exited(_area):
	
	for child in get_children():
		if child.is_inside_tree():
			child.hide()
			exit_sfx.play()

