extends State

@export var Fall_state:State
@export var Charge_state:State
signal block_coyote
func _enter():
	anim_tree.set("parameters/conditions/Jumping",true)
	#print("Jump")
	if Parent.is_on_floor():
		block_coyote.emit()
	Parent.velocity.y=jump_force
	


func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Attack"):
		return Charge_state
	return null

func _update(_delta:float):
	check_col()
	Parent.velocity.y+=gravity*_delta
	var direction=Input.get_axis("Left","Right")
	if direction:
		
		Parent.velocity.x=Move_speed*direction
		if direction>0:
			Parent.sprite.flip_h=false
		else:
			Parent.sprite.flip_h=true
	else :
		Parent.velocity.x = move_toward(Parent.velocity.x, 0, Move_speed)
	if Parent.velocity.y>0:
		return Fall_state
	Parent.move_and_slide()
	return null

func _exit():
	anim_tree.set("parameters/conditions/Jumping",false)

func check_col():
	for i in Parent.get_slide_collision_count():
		var collision=Parent.get_slide_collision(i)
		var caja_collider=collision.get_collider()
		if caja_collider.is_in_group("Cajas") and abs(caja_collider.get_linear_velocity().x)<200:
			#print(caja_collider.get_linear_velocity().x)
			caja_collider.apply_central_impulse(-collision.get_normal()*100)
