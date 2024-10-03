extends Node
class_name manager
var current_state:State=null
@export var Initial_state:State=null

func init(parent:CharacterBody2D, anim_tree:AnimationTree):
	for child in get_children():
		child.Parent=parent
		child.anim_tree=anim_tree
		child.connect("change_state",_on_change_state)
	if Initial_state:
		print(Initial_state)
		change_state(Initial_state)

func change_state(new_state:State):
	if current_state:
		current_state._exit()
	current_state=new_state
	current_state._enter()

func _process(delta):
	var new_state=current_state._update(delta)
	if new_state:
		change_state(new_state)


func _input(event):
	var new_state=current_state._handle_inputs(event)
	if new_state:
		change_state(new_state)

func _on_change_state(newState:State):
	print("check")
	change_state(newState)
