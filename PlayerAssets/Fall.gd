extends State



@export var Charge_state:State
@export var Idle_State:State
@export var Walk_state:State

@export var LEVEL_BOTTOM:int=600

func _enter():
	print("Fall")
	anim_tree.set("parameters/conditions/Falling",true)


func _update(_delta:float):
	Parent.velocity.y+=gravity*_delta
	if Parent.global_position.y>LEVEL_BOTTOM:
		SignalBus.player_dead.emit()
	var direction=Input.get_axis("Left","Right")
	if direction:
		Parent.velocity.x=Move_speed*direction
		if direction>0:
			Parent.sprite.flip_h=false
		else:
			Parent.sprite.flip_h=true
	Parent.move_and_slide()
	if Parent.is_on_floor():
		#print("plop")
		anim_tree.set("parameters/conditions/Falling",false)
		anim_parameters.travel("Land")
		if direction:
			
			return Walk_state
		else:
			
			return Idle_State
	
	return null
#
#func _exit_tree():
	#anim_tree.set("parameters/conditions/Landing",false)

func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Attack"):
		return Charge_state
	return null
