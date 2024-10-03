extends State


@export var Idle_State:State
@export var Walk_State:State
@export var Fall_State:State
@onready var block_movement = $BlockMovement
var can_move=false

func _enter():
	print("Knocked")
	
	can_move=false
	block_movement.start()

func _update(_delta:float):
	Parent.move_and_slide()
	if !Parent.is_on_floor() and can_move:
		return Fall_State
	if can_move:
		return Idle_State
	Parent.velocity.y+=gravity*_delta
	return null

func _on_block_movement_timeout():
	can_move=true

func _handle_inputs(event:InputEvent):
	var direction=Input.get_axis("Left","Right")
	
	if direction and can_move:
		return Walk_State
