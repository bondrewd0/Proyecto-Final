extends State

@export var Idle_State:State
@export var Fall_State:State
@export var Max_charge:float=10.0
var shot_cooldown:Timer
var can_shoot:bool=true
@onready var proyectile_ref=preload("res://PlayerAssets/Proyectile.tscn")
var proyectile_active:bool=false
var proyectile_instance=null
var can_charge:bool=true
var charge_level:float=1.0
@export var charge_step:float=0.01:
	set(new_value):
		if new_value<=0.5 and new_value>0:
			charge_step=new_value
var enemy_ref:Enemy=null
var prop_ref:RigidBody2D=null
@onready var charge_meter = $"../../PlayerUi/ChargeLevel"


func _enter():
	if !SignalBus.enemy_marked.is_connected(setmarked_enemy):
		SignalBus.enemy_marked.connect(setmarked_enemy)
		SignalBus.unmark_enemy.connect(free_marked_enemy)
	if !SignalBus.prop_marked.is_connected(set_prop_ref):
		SignalBus.prop_marked.connect(set_prop_ref)
		SignalBus.unmark_prop.connect(free_marked_prop)
	#print("Can shoot: ",can_shoot)
	if can_shoot:
		can_charge=true
		anim_tree.set("parameters/conditions/Charging",true)
	elif proyectile_instance:
		teleport()


func _handle_inputs(event:InputEvent):
	if event.is_action_released("Attack"):
		if can_shoot:
			can_shoot=false
			can_charge=false
			fire_proyectile()
		else: 
			if proyectile_instance:
				teleport()
	if event.is_action("Jump") and Parent.is_on_floor():
		#print("jump")
		Parent.velocity.y=jump_force
	return null

func _exit():
	anim_tree.set("parameters/conditions/Charging",false)
	charge_meter.reset()
	charge_level=0


func free_proyectile():
	#print("despawned")
	proyectile_instance=null
	can_shoot=true

func fire_proyectile():
	#print("amount: ",charge_level)
	#print("Fire!")
	proyectile_instance=proyectile_ref.instantiate()
	proyectile_instance.global_position=Parent.global_position
	proyectile_instance.direction=get_sprite_direction()
	proyectile_instance.SPEED_MOD=charge_level
	proyectile_instance.connect("despawned",free_proyectile)
	Parent.get_parent().add_child(proyectile_instance)
	

func _update(_delta:float):
	Parent.move_and_slide()
	if can_charge:
		charge_level+=charge_step
		charge_level=clampf(charge_level,1.0,Max_charge)
		charge_meter.set_charge_level(charge_level)
	else:
		return Idle_State
	if !Parent.is_on_floor():
		if can_charge:
			Parent.velocity.y+=gravity*_delta
		elif Parent.velocity.y>0:
			return Fall_State
	
	return null

func teleport():
	if enemy_ref:
		#print("TP to: ",proyectile_instance.global_position)              
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
	#print(enemy_reference)
	enemy_ref=enemy_reference
	#print("Enemy at: ",enemy_ref.global_position)

func free_marked_enemy():
	enemy_ref=null
	free_proyectile()
	#print("free")

func set_prop_ref(prop:RigidBody2D):
	prop_ref=prop


func free_marked_prop():
	prop_ref=null

	free_proyectile()
