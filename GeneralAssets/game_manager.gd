extends Node2D

@export var Initial_scene:PackedScene
@onready var pause = %Pause
@onready var end_screen = %EndScreen
@onready var death_sfx = $Sound/DeathSfx
@onready var level_text = %levelText
@onready var settings = %Settings

@onready var death_screen=%GameOver
@onready var transition_screen = %TransitionScreen
var last_checkPoint:Vector2
var next_level_ref:PackedScene
var level_count=1
var current_level:Level=null
var on_menu:bool=false

var action:int=0
func _ready():
	print(AudioServer.get_bus_volume_db(2))
	on_menu=true
	SignalBus.reset_game.connect(reset)
	SignalBus.player_dead.connect(player_death)
	SignalBus.set_checkpoint.connect(player_check_point)
	SignalBus.pass_level.connect(change_level)
	SignalBus.game_completed.connect(_on_level_completed)
	$UI/LevelIndicator.hide()

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
	level_count+=1
	level_text.text="[b][center]Level: %s"%level_count
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
	death_sfx.play()


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
	$UI/LevelIndicator.show()
	level_text.text="[b][center]Level: %s"%level_count
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
	$UI/LevelIndicator.hide()
	level_count=1
	end_screen.hide()
	$UI/MenuScene.show()


func _on_settings_sound_v_changed(new_value):
	var current_volume=AudioServer.get_bus_volume_db(2)
	AudioServer.set_bus_volume_db(2,current_volume+new_value/10)



func _on_menu_scene_open_settings():
	settings.show()


func _on_settings_music_v_changed(new_value):
	var current_volume=AudioServer.get_bus_volume_db(1)
	AudioServer.set_bus_volume_db(1,current_volume+new_value/10)
