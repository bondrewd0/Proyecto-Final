extends CanvasLayer

@onready var anim_player = $AnimationPlayer
signal transition_finished


func fade_in():
	anim_player.play("Fade")

func fade_out():
	anim_player.play("FadeOut")

func _on_animation_player_animation_finished(anim_name):
	if anim_name=="Fade":
		transition_finished.emit()
