extends Node
class_name Health_Value
@export var Max_Health:float=10
@export var Health:int=1:
	set(new_value):
		if new_value<=Max_Health:
			Health=new_value

signal health_change(new_value)

func damage(dmg_amount:int):
	Health-=dmg_amount
	health_change.emit(Health)
	print("HP: ",Health)
	if Health==0:
		SignalBus.player_dead.emit()

func heal():
	Health=Max_Health
	health_change.emit(Health)
