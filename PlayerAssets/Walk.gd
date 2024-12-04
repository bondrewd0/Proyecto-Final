extends State


@export var Idle_State:State
@export var Jump_State:State
@export var Fall_State:State
@onready var walk_sound = $WalkSFX

func _enter():
	#print("Walk")
	anim_tree.set("parameters/conditions/Walking",true)
	walk_sound.play()

func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Down") and Parent.is_on_floor():
		Parent.position.y+=2
		Parent.move_and_slide()
	if event.is_action_pressed("Jump"):
		return Jump_State
	return null

func _update(_delta:float):
	check_col()
	#walk_sound.global_position=Parent.global_position
	if !walk_sound.playing:
		walk_sound.play()
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
	walk_sound.stop()
	anim_tree.set("parameters/conditions/Walking",false)

func check_col():
	for i in Parent.get_slide_collision_count():
		var collision=Parent.get_slide_collision(i)
		var caja_collider=collision.get_collider()
		if caja_collider.is_in_group("Cajas") and abs(caja_collider.get_linear_velocity().x)<200:
			caja_collider.apply_central_impulse(-collision.get_normal()*100)
