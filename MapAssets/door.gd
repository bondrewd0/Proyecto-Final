extends StaticBody2D

@onready var anim_player = $AnimationPlayer
var is_open:bool=false
@export var One_use:bool=false

func action():
	if One_use:
		anim_player.play("Open")
	else:
		if !is_open:
			anim_player.play("Open")
			is_open=true
		else:
			anim_player.play("Close")
			is_open=false
