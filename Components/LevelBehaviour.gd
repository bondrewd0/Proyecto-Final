extends Node2D
class_name Level
@export var player:Player=null
@export var player_spawn_point:Marker2D
@export var respawnPoint:Marker2D
@export var Next_level:PackedScene
@export var Level_path:String
@export var portal:Portal
# Called when the node enters the scene tree for the first time.
func _ready():
	player.position=player_spawn_point.position
	respawnPoint.global_position=player_spawn_point.global_position
	portal.entered.connect(_on_portal_entered)

func reset_level():
	print("MANCO")
	player.queue_free()
	despawn_all()

func despawn_all():
	SignalBus.despawn_all.emit()


func _on_portal_entered():
	SignalBus.pass_level.emit(Next_level)

func on_retry():
	player.global_position=respawnPoint.global_position

func set_respawn_location(new_position:Vector2):
	respawnPoint.global_position=new_position
