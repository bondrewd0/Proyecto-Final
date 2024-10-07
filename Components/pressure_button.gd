extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@export var Attached_Object:Node2D=null

func  _ready():
	sprite.play("Off")

func _on_pressure_detector_body_entered(body):
	print("bodypisado")
	sprite.play("Pressed")
	if Attached_Object:
		Attached_Object.action()


func _on_pressure_detector_body_exited(body):
	sprite.play("Off")
	if Attached_Object:
		Attached_Object.action()
