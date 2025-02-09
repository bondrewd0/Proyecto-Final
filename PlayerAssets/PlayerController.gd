extends CharacterBody2D
class_name Player
@onready var Body = $PhysicalBod
@onready var anim_player = $AnimPlayer
@onready var anim_tree = $AnimTree
@onready var sprite = $Sprite2D
@onready var state_manager = $StateManager
@onready var speed = $Speed
@onready var anim = $Anim
@export var health_component:Health_Value
@export var KNOCBACK_POWER:float=500
var player_dir:int=0
@export var knocked_state:State
var interactable_object:DeviceBase=null

func _ready():
	state_manager.init(self,anim_tree)
	pass

func _process(_delta):
	var aux=anim_tree.get("parameters/playback")
	speed.text="Speeds= %s"%velocity
	anim.text="%s"%aux.get_current_node()

func damaged(enemy_dir:float):
	health_component.damage(1)
	state_manager.change_state(knocked_state)
	anim_player.play("Disable_hitbox")
	#print("ouch ", enemy_dir," ",global_position.x)
	var dir=global_position.x-enemy_dir
	if dir<0:
		dir=-1
	else:
		dir=1
	var knockBack=dir*KNOCBACK_POWER
	#print(knockBack)
	velocity.y=-100
	velocity.x=knockBack
	move_and_slide()
	

func _input(event):
	if event.is_action_pressed("Restart"):
		SignalBus.reset_game.emit()
	if event.is_action_pressed("Interact"):
		if interactable_object:
			#print(interactable_object)
			interactable_object.interaction()
	if event.is_action_pressed("Force Despawn"):
		SignalBus.despawn_orb.emit()


func _on_hitbox_area_entered(area):
	var parent=area.get_parent()
	if parent is DeviceBase:
		interactable_object=parent
	if area.collision_layer==1024:
		SignalBus.player_dead.emit()
		pass


func _on_hitbox_area_exited(area):
	var parent=area.get_parent()
	if parent is DeviceBase:
		interactable_object=null
