extends RigidBody2D

@onready var particulas = $GPUParticles2D
var marked:bool=false

func _integrate_forces(state):
	angular_velocity=0
	rotation_degrees=0



func _process(_delta):
	if linear_velocity.x<-0.5:
		particulas.emitting=true
		particulas.position.x=-19
	elif linear_velocity.x>0.5:
		particulas.emitting=true
		particulas.position.x=19
	else:
		particulas.emitting=false


func _on_hitbox_area_entered(area):
	var parent=area.get_parent()
	if parent is Player_Bullet:
		marked=true
		SignalBus.prop_marked.emit(self)
