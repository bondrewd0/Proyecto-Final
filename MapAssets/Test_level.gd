extends Node2D

@onready var player = $Player
@onready var player_spawn_point = $PlayerSpawnPoint
@export var gameover_Screen:String
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
	for child in $Enemies.get_children():
		child.queue_free()
	pass
