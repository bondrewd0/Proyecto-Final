extends Node2D

@export var player:Player=null
@onready var player_spawn_point = $PlayerSpawnPoint
@export var gameover_Screen:String
@export var Next_level:String=""
@onready var transition_screen = $TransitionScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	   
	player.position=player_spawn_point.position
	SignalBus.player_dead.connect(kill_player)


func kill_player():
	print("MANCO")
	player.queue_free()
	var game_over=load(gameover_Screen)
	var aux=game_over.instantiate()
	despawn_all()
	$Mapa.visible=false
	add_child(aux)
	

func despawn_all():
	SignalBus.despawn_all.emit()

func change_level():
	get_tree().paused=false
	get_tree().change_scene_to_file(Next_level)
	


func _on_portal_entered():
	transition_screen.fade_in()
	get_tree().paused=true
