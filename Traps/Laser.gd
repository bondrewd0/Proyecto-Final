extends Trap

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("On")

func _on_hitbox_area_entered(area):
	var parent=area.get_parent()
	if parent is Player:
		parent.damaged(global_position.x)
