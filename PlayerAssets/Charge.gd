extends State

#Referencia a los otros nodos que puede acceder
@export var Idle_State:State
@export var Fall_State:State
@export var Max_charge:float=10.0

#Valor para definir quetan rapido se carga el disparo
@export var charge_step:float=0.01:
	set(new_value):
		if new_value<=0.5 and new_value>0:
			charge_step=new_value
#Referencia para instanciar el proyectil
@onready var proyectile_ref=preload("res://PlayerAssets/Proyectile.tscn")
#Variable para crear timer que evita el disparo continuo
var shot_cooldown:Timer
#Freno al tiro
var can_shoot:bool=true
#Estado del proyectil
var proyectile_active:bool=false
#Instancia del proyectil
var proyectile_instance=null
#Verificador de carga
var can_charge:bool=true
#Nivel de carga
var charge_level:float=1.0
#Referncia a enemigo
var enemy_ref:Enemy=null
#Referencia a objeto
var prop_ref:RigidBody2D=null
#Referencia a la interfaz de la barra de carga
@onready var charge_meter = $"../../PlayerUi/ChargeLevel"
#Referencia a los sonidos
@onready var tpsfx = $TPSFX
@onready var jump_sfx = %JumpSFX

#Al entrar conecta las señales para marcar y desmarcar todo aquello que pueda ser marcado
func _enter():
	if !SignalBus.enemy_marked.is_connected(setmarked_enemy):
		SignalBus.enemy_marked.connect(setmarked_enemy)
		SignalBus.unmark_enemy.connect(free_marked_enemy)
	if !SignalBus.prop_marked.is_connected(set_prop_ref):
		SignalBus.prop_marked.connect(set_prop_ref)
		SignalBus.unmark_prop.connect(free_marked_prop)
	#Si se puede disparar permite cargar el disparo y se mueve a la animacion
	if can_shoot:
		can_charge=true
		anim_tree.set("parameters/conditions/Charging",true)
	#Si no, ejecuta la funcion para cambiar de lugar
	elif proyectile_instance or enemy_ref or prop_ref:
		teleport()
		print("tp")


func _handle_inputs(event:InputEvent):
	#Si se suelta el espcaio
	if event.is_action_released("Attack"):
		#Dispara el proyectil o se teletansporta si existe el proyectil
		if can_shoot:
			can_shoot=false
			can_charge=false
			fire_proyectile()
	#Si se puede saltar ejecuta una version simple del salto
	if event.is_action("Jump") and Parent.is_on_floor():
		#print("jump")
		jump_sfx.play()
		Parent.velocity.y=jump_force
	return null

#elimina la instancia del proyectil y permite volver a disparar
func free_proyectile():
	proyectile_instance=null
	if enemy_ref==null and prop_ref==null:
		can_shoot=true

#Logica de disparo del proyectil
func fire_proyectile():
	#Crea instancia de proyectil y la posiciona segun la posicion del player
	proyectile_instance=proyectile_ref.instantiate()
	proyectile_instance.global_position=Parent.global_position
	#Da direccion y velocidad
	proyectile_instance.direction=get_sprite_direction()
	proyectile_instance.SPEED_MOD=charge_level
	#Conecta la señal del proyectil a la funcion para eliminar la instancia
	proyectile_instance.connect("despawned",free_proyectile)
	#Añade como hijo
	Parent.get_parent().add_child(proyectile_instance)
	

func _update(_delta:float):
	Parent.move_and_slide()
	#Si puede cargar aumenta el nivel hasta cierto punto
	if can_charge:
		charge_level+=charge_step
		charge_level=clampf(charge_level,1.0,Max_charge)
		charge_meter.set_charge_level(charge_level)
	#Si no, revisa si se dejo de cargar y cambia de estado
	else:
		return Idle_State
	if !Parent.is_on_floor():
		if can_charge:
			Parent.velocity.y+=gravity*_delta
		elif Parent.velocity.y>0:
			return Fall_State
	
	return null

#Logica de teletransporte a un objeto o  al proyectil
func teleport():
	tpsfx.play()
	if enemy_ref:            
		var current_pos=Parent.global_position
		Parent.global_position=enemy_ref.global_position
		enemy_ref.global_position=current_pos
		enemy_ref.global_position.y-=50
		enemy_ref.moved()
	elif prop_ref:
		var current_pos=Parent.global_position
		Parent.global_position=prop_ref.get_node("PlayerTpPosition").global_position
		prop_ref.move(current_pos)
		free_marked_prop()
	else:
		Parent.global_position=proyectile_instance.global_position
		proyectile_instance.force_despawn()
	free_proyectile()

func setmarked_enemy(enemy_reference:Enemy):
	enemy_ref=enemy_reference

func free_marked_enemy():
	enemy_ref=null
	free_proyectile()

#Inicia la referencia al objeto marcado para ser usado
func set_prop_ref(prop:RigidBody2D):
	prop_ref=prop

#Libera la referencia al objeto marcado
func free_marked_prop():
	prop_ref=null
	free_proyectile()

#Al saslir resetea la carga y la barra a 0
func _exit():
	anim_tree.set("parameters/conditions/Charging",false)
	charge_meter.reset()
	charge_level=0
