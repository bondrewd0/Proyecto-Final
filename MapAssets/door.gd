extends StaticBody2D

@onready var anim_player = $AnimationPlayer
var is_open:bool=false
@export var One_use:bool=false
@onready var sfx = $SFX

func action():
	if not sfx.playing and is_inside_tree():
		sfx.play()
	if One_use:
		anim_player.play("Open")
	else:
		if !is_open:
			anim_player.play("Open")
			is_open=true
		else:
			anim_player.play("Close")
			is_open=false
