extends StaticBody2D

@onready var anim_player = $AnimationPlayer



func action():
	anim_player.play("Open")
