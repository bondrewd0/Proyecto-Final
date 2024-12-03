extends CanvasLayer

@onready var anim_player = $AnimationPlayer
signal transition_finished
@onready var s_fx = $SFx


func fade_in():
	s_fx.play()
	anim_player.play("Fade")

func fade_out():
	anim_player.play("FadeOut")

func _on_animation_player_animation_finished(anim_name):
	if anim_name=="Fade":
		await s_fx.finished
		transition_finished.emit()
