extends Trap

@onready var animation_player = $AnimationPlayer
@onready var paticles = $GPUParticles2D

func _ready():
	animation_player.play("On")

func _on_hitbox_area_entered(area):
	var parent=area.get_parent()
	if parent is Player:
		parent.damaged(global_position.x)

func turn_off():
	animation_player.play("Shut_Down")
	paticles.emitting=false
	


func turn_on():
	animation_player.play("On")
	paticles.emitting=true
