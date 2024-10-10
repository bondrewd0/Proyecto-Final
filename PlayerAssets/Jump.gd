extends State

@export var Fall_state:State
@export var Charge_state:State
signal block_coyote
func _enter():
	print("Jump")
	if Parent.is_on_floor():
		block_coyote.emit()
	Parent.velocity.y=jump_force
	anim_tree.set("parameters/conditions/Jumping",true)


func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Attack"):
		return Charge_state
	return null

func _update(_delta:float):
	Parent.velocity.y+=gravity*_delta
	var direction=Input.get_axis("Left","Right")
	if direction:
		
		Parent.velocity.x=Move_speed*direction
		if direction>0:
			Parent.sprite.flip_h=false
		else:
			Parent.sprite.flip_h=true
	if Parent.velocity.y>0:
		return Fall_state
	Parent.move_and_slide()
	return null

func _exit():
	anim_tree.set("parameters/conditions/Jumping",false)
