extends State



@export var Charge_state:State
@export var Idle_State:State
@export var Walk_state:State
@export var Jump_state:State
@onready var coyote_timer = $Coyote_Timer

@export var LEVEL_BOTTOM:int=600
var can_jump:bool=true
var has_jumpped:bool=false
func _enter():
	coyote_timer.start()
	#print("Fall")
	anim_tree.set("parameters/conditions/Falling",true)


func _update(_delta:float):
	check_col()
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
	else :
		Parent.velocity.x = move_toward(Parent.velocity.x, 0, Move_speed)
	Parent.move_and_slide()
	if Parent.is_on_floor():
		#print("plop")
		anim_tree.set("parameters/conditions/Falling",false)
		
		if direction:
			
			return Walk_state
		else:
			anim_parameters.travel("Land")
			return Idle_State
	
	return null
#
func _exit():
	can_jump=true
	if !coyote_timer.is_stopped():
		coyote_timer.stop()
	anim_tree.set("parameters/conditions/Landing",false)

func _handle_inputs(event:InputEvent):
	if event.is_action_pressed("Attack"):
		return Charge_state
	if event.is_action_pressed("Jump") and can_jump:
		return Jump_state
	return null

func coyote_timeout():
	#print("NO")
	can_jump=false

func has_jumped():
	can_jump=false

func check_col():
	for i in Parent.get_slide_collision_count():
		var collision=Parent.get_slide_collision(i)
		var caja_collider=collision.get_collider()
		if caja_collider.is_in_group("Cajas") and abs(caja_collider.get_linear_velocity().x)<200:
			#print(caja_collider.get_linear_velocity().x)
			caja_collider.apply_central_impulse(-collision.get_normal()*100)

func _ready():
	SignalBus.set_bottom.connect(set_minimun_fall)

func set_minimun_fall(value:float):
	print(value)
	LEVEL_BOTTOM=value
