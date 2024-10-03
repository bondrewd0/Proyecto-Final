extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.player_dead.connect(kill_player)


func kill_player():
	print("MANCO")
	player.queue_free()
