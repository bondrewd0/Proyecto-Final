extends Sprite2D
class_name  DeviceBase

@export var Attached_Object:Node2D=null
@onready var animplayer = $AnimationPlayer
@export var One_use:bool=false
var action_done:bool=false
var next_anim
@onready var pressed_sfx = $PressedSFX

# Called when the node enters the scene tree for the first time.
func _ready():
	animplayer.play("Off")
	next_anim="On"


func interaction():
	if One_use:
		if action_done:
			pass
		else:
			action()
			action_done=true
	else :
		action()

func action():
	pressed_sfx.play()
	print(Attached_Object)
	animplayer.play(next_anim)
	if next_anim=="On":
		next_anim="Off"
	else:
		next_anim="On"
	if Attached_Object.has_method("action"):
		
		Attached_Object.action()
