extends CanvasLayer

@onready var anim_player = $AnimationPlayer
@export var level_changed:bool=false
signal transition_finished
# Called when the node enters the scene tree for the first time.
func _ready():
	if level_changed:
		anim_player.play("FadeOut")
	pass # Replace with function body.


func fade_in():
	anim_player.play("Fade")


func _on_animation_player_animation_finished(anim_name):
	if anim_name=="Fade":
		transition_finished.emit()
