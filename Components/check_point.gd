extends AnimatedSprite2D
@onready var reference_point = $ReferencePoint
var is_on=false

func _ready():
	play("default")

func _on_area_area_entered(area):
	var parent=area.get_parent()
	if parent is Player:
		
		call_deferred("start_cooldown")


func _on_save_cooldown_timeout():
	
	$Area/CollisionShape2D.disabled=false

func start_cooldown():
	$SaveCooldown.start()
	$Area/CollisionShape2D.disabled=true
	SignalBus.set_checkpoint.emit(reference_point.global_position)
	play("On")
	if  not is_on:
		is_on=true
		$ActivatedSfx.play()
