extends Node
class_name State

var Parent:CharacterBody2D
var anim_parameters
var anim_tree:AnimationTree:
	set(animation_tree):
		
		anim_tree=animation_tree
		anim_parameters=animation_tree.get("parameters/playback")
		#print(anim_parameters)
		#print(anim_tree.get("parameters/conditions"))
var anim_manager:AnimationPlayer
@export var Move_speed:float=400.0
@export var jump_force:float=-300
var gravity=ProjectSettings.get_setting("physics/2d/default_gravity")

signal  change_state(newState:State)

func _enter():
	pass

func _exit():
	pass

func _handle_inputs(event:InputEvent):
	return null

func _update(_delta:float):
	return null

func get_sprite_direction():
	if Parent.has_node("Sprite2D"):
		var parent_sprite=Parent.get_node("Sprite2D")
		if parent_sprite.flip_h :
			return -1
		else:
			return 1
