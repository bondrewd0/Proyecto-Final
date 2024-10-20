extends State


@export var Idle_State:State
@export var Jump_State:State
@export var Fall_State:State

func _enter():
	#print("Walk")
	anim_tree.set("parameters/conditions/Walking",true)

func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Down"):
		Parent.position.y+=1
	if event.is_action_pressed("Jump"):
		return Jump_State
	return null

func _update(_delta:float):
	var direction=Input.get_axis("Left","Right")
	if direction:
		Parent.velocity.x=Move_speed*direction
		if direction>0:
			Parent.sprite.flip_h=false
		else:
			Parent.sprite.flip_h=true
	else:
		return Idle_State
	if !Parent.is_on_floor():
		return Fall_State
	Parent.move_and_slide()
	return null

func _exit():
	anim_tree.set("parameters/conditions/Walking",false)
