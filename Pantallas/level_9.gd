extends Level


func _on_portal_entered():
	SignalBus.game_completed.emit()
