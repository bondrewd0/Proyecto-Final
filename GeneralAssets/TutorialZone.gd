
extends Area2D

@onready var tutorial = $Tutorial
@export var Message:String
@onready var text_size = $TextSize

func _ready():
	tutorial.size=text_size.size
	tutorial.Tutorial_text.size=text_size.size
	text_size.hide()
	tutorial.Tutorial_text.text=Message

func _on_area_entered(area):
	tutorial.show()

func _on_area_exited(area):
	tutorial.hide()
