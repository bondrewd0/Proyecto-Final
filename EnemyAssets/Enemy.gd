extends CharacterBody2D
class_name Enemy

const SPEED = 300.0
@onready var unmarktimer = $UnMarkTimer
@onready var mov_timer = $MovTimer
@onready var light = $PointLight2D

@onready var sprite = $AnimatedSprite2D
@export var MOVE_SPEED:float=100
@export_range(1.0,10.0) var Moving_time:float=1.0

var marked:bool=false
var direction:int=1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move:bool=true
func _ready():
	mov_timer.wait_time=Moving_time
	sprite.play("Move")
	mov_timer.start()
	SignalBus.despawn_all.connect(despawn)

func _physics_process(delta):
	SignalBus.unmark_enemy.emit()
	queue_free()
	if can_move:
		velocity.x=direction*MOVE_SPEED
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	

func _on_hitbox_area_entered(area):
	var parent= area.get_parent()
	if parent is Player:
		#print("HIT")
		parent.damaged(global_position.x)
	if parent is Player_Bullet:
		#print("Tagged!")
		marked=true
		SignalBus.emit_signal("enemy_marked",self)
		unmarktimer.start()
	if area.collision_layer==1024:
		SignalBus.unmark_enemy.emit()
		queue_free()


func _on_un_mark_timer_timeout():
	#print("no longer it")
	marked=false
	SignalBus.unmark_enemy.emit()

func moved():
	unmarktimer.stop()
	mov_timer.stop()
	marked=false
	can_move=false
	move_and_slide()
	mov_timer.start()
	velocity.y=-200
	SignalBus.unmark_enemy.emit()


func _on_mov_timer_timeout():
	#print("ding",direction)
	can_move=!can_move
	if direction==1:
		sprite.flip_h=false
		light.rotation=0
	else:
		sprite.flip_h=true
		light.rotation=3
	if !can_move:
		direction*=-1
		velocity.x=0
		sprite.play("Idle")
		#print("waiting")
	else:
		sprite.play("Move")
		#print("Moving")
	#print(mov_timer.wait_time, direction)
	mov_timer.start()

func despawn():
	queue_free()
