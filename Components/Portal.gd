extends AnimatedSprite2D
class_name  Portal
@export var Active:bool=false

signal entered
# Called when the node enters the scene tree for the first time.
func _ready():
	if Active:
		play("Idle")
	else:
		play("Off")
	pass # Replace with function body.

func action():
	if Active:
		Active=false
		play_backwards("Activate")
	else:
		Active=true
		play("Activate")


func _on_animation_finished():
	if animation=="Activate" and Active:
		play("Idle")



func _on_hit_box_body_entered(_body):
	if Active:
		entered.emit()
