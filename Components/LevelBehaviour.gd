extends Node2D
class_name Level
@export var player:Player=null
@export var player_spawn_point:Marker2D
@export var Next_level:PackedScene
@export var Level_path:String
# Called when the node enters the scene tree for the first time.
func _ready():
	player.position=player_spawn_point.position

func reset_level():
	print("MANCO")
	player.queue_free()
	despawn_all()

func despawn_all():
	SignalBus.despawn_all.emit()


func _on_portal_entered():
	SignalBus.pass_level.emit(Next_level)
