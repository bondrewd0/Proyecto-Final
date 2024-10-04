extends Path2D
class_name MovingObject

@export var loop:bool=false
@export var Object_to_Move:PhysicsBody2D=null
@export var Speed:float=1
@onready var tf_2d = $PathFollow2D/RemoteTransform2D
@export var speed_scale:float=1.0
@onready var path_follow_2d = $PathFollow2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	tf_2d.remote_path=Object_to_Move.get_path()
	if !loop:
		animation_player.play("move")
		animation_player.speed_scale=speed_scale
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loop:
		path_follow_2d.progress+=Speed

func deactivate():
	if Object_to_Move is Trap:
		Object_to_Move.turn_off()


func _on_animation_player_animation_finished(anim_name):
	print("Finished")
