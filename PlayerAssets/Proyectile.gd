extends CharacterBody2D
class_name Player_Bullet
@onready var hit_box = $HitBox
@onready var despawner = $Despawner
@onready var animation_player = $AnimationPlayer

@export var  SPEED = 100.0
@export var deceleration:float=1.0
var SPEED_MOD:float=1.0
var direction:int=0
signal despawned
func _ready():
	#print("pum")
	deceleration=((SPEED_MOD*deceleration)/2)*-direction
	animation_player.play("Dissipate")
	despawner.wait_time=4/SPEED_MOD
	#print("Tiempo de vida: ",despawner.wait_time)
	despawner.start()
	velocity.x=(SPEED*direction*SPEED_MOD)
	#print(global_position)

func _physics_process(_delta):
	velocity.x+=deceleration
	move_and_slide()
	


func _on_hit_box_area_entered(area):
	var parent=area.get_parent()
	if parent is Enemy:
		#print("Tagged you are it")
		queue_free()
	if parent is Trap:
		despawned.emit()
		queue_free()
	if area.get_collision_layer()==8:
		queue_free()



func _on_despawner_timeout():
	emit_signal("despawned")
	queue_free()

func force_despawn():
	get_parent().remove_child(self)
	queue_free()


func _on_hit_box_body_entered(body):
	
	if body is TileMap:
		emit_signal("despawned")
		queue_free()
	elif body.get_collision_layer()==2:
		despawned.emit()
		queue_free()
