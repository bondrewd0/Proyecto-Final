extends Trap

@onready var animation_player = $AnimationPlayer
@onready var paticles = $GPUParticles2D
var is_on:bool=true

func _ready():
	animation_player.play("On")

func _on_hitbox_area_entered(area):
	var parent=area.get_parent()
	if parent is Player:
		parent.damaged(global_position.x)

func turn_off():
	is_on=false
	animation_player.play("Shut_Down")
	paticles.emitting=false
	


func turn_on():
	is_on=true
	animation_player.play("On")
	paticles.emitting=true

func action():
	if is_on:
		turn_off()
	else:
		turn_on()
