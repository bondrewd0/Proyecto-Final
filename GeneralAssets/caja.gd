extends RigidBody2D

@onready var particulas = $GPUParticles2D
var marked:bool=false
var reset_state=false
var player_position=Vector2.ZERO
@onready var tagged_effect = $TaggedEffect
@onready var un_tag = $UnTag


func _integrate_forces(state):
	angular_velocity=0
	rotation_degrees=0
	#cuando las fisicas esten desactivadas y quiera cambiar de lugar
	if reset_state:
		#pongo el freno para no hacerlo mas de una vez
		reset_state=false
		#cambio la posicion y reseteo la posicion recibida
		position=player_position
		player_position=Vector2.ZERO
		#reactivo las fisicas para que cambie de lugar
		custom_integrator=false



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
		tagged_effect.show()
		tagged_effect.play("On")
		SignalBus.prop_marked.emit(self)
		un_tag.start()

func move(pos:Vector2):
	#Activo esto para que deje de usar motor de fisicas y usa la func integrate forces
	custom_integrator=true
	player_position=pos
	#Le indico a la funcion que ejecute la parte de cambio de pos
	reset_state=true
	#congelo el objeto para que no salga disparado
	freeze=true
	$Delay.start()
	tagged_effect.pause()
	tagged_effect.hide()


#descongelo el objeto
func _on_delay_timeout():
	freeze=false


func _on_un_tag_timeout():
	print("tarde")
	SignalBus.unmark_prop.emit()
	tagged_effect.pause()
	tagged_effect.hide()
	marked=false
