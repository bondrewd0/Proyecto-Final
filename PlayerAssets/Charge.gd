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
var enemy_ref:Enemy=null

func _enter():
	if !SignalBus.enemy_marked.is_connected(setmarked_enemy):
		SignalBus.enemy_marked.connect(setmarked_enemy)
		SignalBus.unmark_enemy.connect(free_marked_enemy)
	print("Can shoot: ",can_shoot)
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
	if event.is_action("Jump"):
		print("jump")
		Parent.velocity.y=jump_force
	return null

func _exit():
	anim_tree.set("parameters/conditions/Charging",false)


func free_proyectile():
	print("despawned")
	proyectile_instance=null
	can_shoot=true

func fire_proyectile():
	print("amount: ",charge_level)
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
		charge_level+=0.01
		charge_level=clampf(charge_level,1.0,Max_charge)
	else:
		return Idle_State
	if !Parent.is_on_floor():
		if can_charge:
			Parent.velocity.y+=gravity*_delta
		else :
			return Fall_State
	
	return null

func teleport():
	if !enemy_ref:
		#print("TP to: ",proyectile_instance.global_position)              
		Parent.global_position=proyectile_instance.global_position
		proyectile_instance.force_despawn()
	else:
		var current_pos=Parent.global_position
		Parent.global_position=enemy_ref.global_position
		enemy_ref.global_position=current_pos
		enemy_ref.moved()
	free_proyectile()
	

func setmarked_enemy(enemy_reference:Enemy):
	#print(enemy_reference)
	enemy_ref=enemy_reference
	#print("Enemy at: ",enemy_ref.global_position)

func free_marked_enemy():
	enemy_ref=null
	free_proyectile()
	#print("free")
