extends ColorRect

@onready var tutorial = $Tutorial2
@export var Message:String


func _ready():
	tutorial.size=size
	tutorial.Tutorial_text.size=size
	self_modulate=Color(1,1,1,0)
	tutorial.Tutorial_text.text="[b][center]"+Message


func _on_tutorial_area_entered(area):
	for child in get_children():
		child.show()


func _on_tutorial_area_exited(area):
	for child in get_children():
		child.hide()

