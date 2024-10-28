extends Node2D

@export var Initial_scene:PackedScene

var current_scene

func _ready():
	SignalBus.reset_game.connect(reset)
	SignalBus.set_checkpoint.connect(player_check_point)
	var instance=Initial_scene.instantiate()
	add_child(instance)
	move_child(instance,0)
	current_scene=instance
	print(type_string(typeof(Initial_scene)))

func reset():
	pass

func player_check_point(position):
	pass

func change_level(new_level:PackedScene):
	remove_child(get_child(0))
	var instance=new_level.instantiate()
	add_child(instance)
	move_child(instance,0)
