extends MovingObject
var stopped:bool=false
@export var can_stop:bool=false
@onready var laser = $Laser
@export var stop_time:float=1.0

func _ready():
	super()
	$Timer.wait_time=stop_time

func _process(_delta):
	if !stopped:
		path_follow_2d.progress+=Speed
	if can_stop and path_follow_2d.progress_ratio>=0.99 and !stopped:
		stopped=true
		$Timer.start()
		laser.turn_off()
	

func _on_timer_timeout():
	laser.turn_on()
	stopped=false
	

func action():
	if  !stopped:
		if !$Timer.is_stopped():
			$Timer.stop()
		stopped=true
		animation_player.pause()
	else:
		stopped=false
		animation_player.play("move")
	laser.action()
