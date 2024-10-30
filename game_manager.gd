extends Node2D

@export var Initial_scene:PackedScene

@onready var death_screen=%Fondo
@onready var transition_screen = %TransitionScreen
var last_checkPoint:Vector2
var next_level_ref=PackedScene

var current_level:Level=null

var action:int=0
func _ready():
	SignalBus.reset_game.connect(reset)
	SignalBus.player_dead.connect(player_death)
	SignalBus.set_checkpoint.connect(player_check_point)
	SignalBus.pass_level.connect(change_level)
	

func reset():
	action=2
	transition_screen.fade_in()
	get_tree().paused=true
	next_level_ref=load(current_level.Level_path)as PackedScene
	call_deferred("remove_current_level")

func player_check_point(position):
	last_checkPoint=position

func change_level(new_level:PackedScene):
	action=1
	get_tree().paused=true
	next_level_ref=new_level
	transition_screen.fade_in()
	call_deferred("remove_current_level")

func remove_current_level():
	remove_child(get_child(0))
	current_level.queue_free()
	current_level=null

func player_death():
	current_level.reset_level()
	death_screen.show()
	death_screen.play_anim()


func _on_transition_screen_transition_finished():
	match action:
		1:
			var instance=next_level_ref.instantiate()
			add_child(instance)
			move_child(instance,0)
			current_level=instance
			last_checkPoint=Vector2.ZERO
		2:
			var instance=next_level_ref.instantiate()
			add_child(instance)
			move_child(instance,0)
			current_level=instance
			if last_checkPoint != Vector2.ZERO:
				current_level.set_respawn_location(last_checkPoint)
				current_level.on_retry()
			death_screen.hide()
			action=0
	get_tree().paused=false
	transition_screen.fade_out()


func _input(event):
	if event.is_action("Restart"):
		SignalBus.reset_game.emit()


func _on_menu_scene_begin_game():
	var instance=Initial_scene.instantiate()
	add_child(instance)
	move_child(instance,0)
	current_level=instance
	print(current_level)
