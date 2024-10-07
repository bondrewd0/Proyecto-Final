extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@export var Attached_Object:Node2D=null
@onready var light = $PointLight2D

func  _ready():
	light.enabled=false
	sprite.play("Off")

func _on_pressure_detector_body_entered(_body):
	print("bodypisado")
	light.enabled=true
	sprite.play("Pressed")
	if Attached_Object:
		Attached_Object.action()


func _on_pressure_detector_body_exited(_body):
	sprite.play("Off")
	light.enabled=false
	if Attached_Object:
		Attached_Object.action()
