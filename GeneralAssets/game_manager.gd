extends Node2D

@export var Initial_scene:PackedScene
@onready var pause = %Pause
@onready var end_screen = %EndScreen
@onready var death_sfx = $Sound/DeathSfx
@onready var level_text = %levelText
@onready var settings = %Settings
@onready var area_1_music = %Area1Music
@onready var area_2_music = %Area2Music
@onready var area_3_music = %Area3Music
@onready var menu_music = %MenuMusic
@onready var game_over_music = %GameOverMusic

@onready var death_screen=%GameOver
@onready var transition_screen = %TransitionScreen
@export var levels:Array[PackedScene]
var last_checkPoint:Vector2
var next_level_ref:PackedScene
var level_count=1
var current_level:Level=null
var on_menu:bool=false
var current_area_music:AudioStreamPlayer2D

var action:int=0
func _ready():
	on_menu=true
	SignalBus.reset_game.connect(reset)
	SignalBus.player_dead.connect(player_death)
	SignalBus.set_checkpoint.connect(player_check_point)
	SignalBus.pass_level.connect(change_level)
	SignalBus.game_completed.connect(_on_level_completed)
	menu_music.play()
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
	if level_count==4:
		current_area_music.stop()
		current_area_music=area_2_music
		current_area_music.play()
	if level_count==7:
		current_area_music.stop()
		current_area_music=area_3_music
		current_area_music.play()
	match level_count:
		1, 2, 3:
			if not area_1_music.playing:
				area_1_music.play()
		4,5,6:
			if not area_2_music.playing:
				area_2_music.play()
		7,8,9:
			if not area_3_music.playing:
				area_3_music.play()
	level_text.text="[b][center]Level: %s"%level_count
	get_tree().paused=true
	next_level_ref=new_level
	transition_screen.fade_in()
	call_deferred("remove_current_level")

func remove_current_level():
	remove_child(get_child(0))
	current_level.queue_free()
	current_level=null

func player_death():
	current_area_music.stop()
	current_level.reset_level()
	death_screen.show()
	death_screen.play_anim()
	death_sfx.play()
	game_over_music.play()


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
			game_over_music.stop()
			current_area_music.play()
			action=0
	get_tree().paused=false
	transition_screen.fade_out()


func _input(event):
	if Input.is_key_pressed(KEY_1):
		print(levels[0])
		Initial_scene=levels[0]
	if Input.is_key_pressed(KEY_2):
		print(levels[1])
		Initial_scene=levels[1]
	if Input.is_key_pressed(KEY_3):
		print(levels[2])
		Initial_scene=levels[2]
	if Input.is_key_pressed(KEY_4):
		print(levels[3])
		Initial_scene=levels[3]
	if Input.is_key_pressed(KEY_5):
		print(levels[4])
		Initial_scene=levels[4]
	if Input.is_key_pressed(KEY_6):
		print(levels[5])
		Initial_scene=levels[5]
	if event.is_action_pressed("Pause"):
		if on_menu:
			get_tree().quit()
		else :
			on_menu=true
			pause.show()
			get_tree().paused=true


func _on_menu_scene_begin_game():
	$UI/LevelIndicator.show()
	menu_music.stop()
	level_text.text="[b][center]Level: %s"%level_count
	var instance=Initial_scene.instantiate()
	current_area_music=area_1_music
	current_area_music.play()
	add_child(instance)
	move_child(instance,0)
	current_level=instance
	on_menu=false


func _on_pause_unpause():
	on_menu=false

func _on_level_completed():
	end_screen.show()
	game_over_music.play()
	call_deferred("remove_current_level")


func _on_end_screen_bact_to_menu():
	$UI/LevelIndicator.hide()
	level_count=1
	end_screen.hide()
	game_over_music.play()
	$UI/MenuScene.show()
	menu_music.play()


func _on_settings_sound_v_changed(new_value):
	AudioServer.set_bus_volume_db(2,new_value)



func _on_menu_scene_open_settings():
	settings.show()


func _on_settings_music_v_changed(new_value):
	AudioServer.set_bus_volume_db(1,new_value)



func _on_pause_open_settings():
	settings.show()
