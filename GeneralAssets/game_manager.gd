extends Node2D

@export var Initial_scene:PackedScene
@onready var pause = %Pause
@onready var end_screen = %EndScreen

@onready var death_screen=%GameOver
@onready var transition_screen = %TransitionScreen
var last_checkPoint:Vector2
var next_level_ref:PackedScene

var current_level:Level=null
var on_menu:bool=false

var action:int=0
func _ready():
	on_menu=true
	SignalBus.reset_game.connect(reset)
	SignalBus.player_dead.connect(player_death)
	SignalBus.set_checkpoint.connect(player_check_point)
	SignalBus.pass_level.connect(change_level)
	SignalBus.game_completed.connect(_on_level_completed)

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
	print(new_level)
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
	if event.is_action_pressed("Pause"):
		if on_menu:
			get_tree().quit()
		else :
			on_menu=true
			pause.show()
			get_tree().paused=true


func _on_menu_scene_begin_game():
	var instance=Initial_scene.instantiate()
	add_child(instance)
	move_child(instance,0)
	current_level=instance
	print(current_level)
	on_menu=false


func _on_pause_unpause():
	on_menu=false

func _on_level_completed():
	end_screen.show()
	call_deferred("remove_current_level")


func _on_end_screen_bact_to_menu():
	end_screen.hide()
	$UI/MenuScene.show()
