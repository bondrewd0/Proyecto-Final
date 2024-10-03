extends CharacterBody2D
class_name Player
@onready var Body = $PhysicalBod
@onready var anim_player = $AnimPlayer
@onready var anim_tree = $AnimTree
@onready var sprite = $Sprite2D
@onready var state_manager = $StateManager
@onready var speed = $Speed
@onready var anim = $Anim
@export var KNOCBACK_POWER:float=500
var player_dir:int=0
@export var knocked_state:State
func _ready():
	state_manager.init(self,anim_tree)
	pass

func _process(_delta):
	var aux=anim_tree.get("parameters/playback")
	speed.text="Speeds= %s"%velocity
	anim.text="%s"%aux.get_current_node()

func damaged(enemy_dir:float):
	state_manager.change_state(knocked_state)
	anim_player.play("Disable_hitbox")
	print("ouch ", enemy_dir," ",global_position.x)
	var dir=global_position.x-enemy_dir
	if dir<0:
		dir=-1
	else:
		dir=1
	var knockBack=dir*KNOCBACK_POWER
	print(knockBack)
	velocity.y=-100
	velocity.x=knockBack
	move_and_slide()
	
