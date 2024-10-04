extends State

@export var Walk_State:State
@export var Jump_State:State
@export var Fall_State:State
@export var Charge_state:State

func _enter():
	get_sprite_direction()
	#print("Idle")
	Parent.velocity.x=move_toward(Parent.velocity.x,0,Move_speed)
	anim_tree.set("parameters/conditions/Idle",true)

func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Down") and Parent.is_on_floor():
		Parent.position.y+=1
		
	var direction=Input.get_axis("Left","Right")
	if direction:
		return Walk_State
	if event.is_action_pressed("Jump"):
		return Jump_State
	if event.is_action_pressed("Attack"):
		return Charge_state
	return null

func _update(_delta:float):
	Parent.move_and_slide()
	if !Parent.is_on_floor():
		return Fall_State
	return null

func _exit():
	anim_tree.set("parameters/conditions/Idle",false)
