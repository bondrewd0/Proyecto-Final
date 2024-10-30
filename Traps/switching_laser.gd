extends Node2D
@onready var laser = $Laser
@onready var switch = $Switch
@export var On_time:float=1.0
@export var Off_time:float=1.0
var is_on:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	is_on=true
	switch.wait_time=On_time


func _on_switch_timeout():
	if is_on:
		laser.turn_off()
		is_on=false
		switch.wait_time=Off_time
	else:
		is_on=true
		laser.turn_on()
		switch.wait_time=On_time
	switch.start()
	print(switch.wait_time)
