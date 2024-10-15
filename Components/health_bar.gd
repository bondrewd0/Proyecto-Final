extends TextureProgressBar

@export var healthComp:Health_Value=null

func _ready():
	healthComp.health_change.connect(health_changed)

func health_changed(new_health:int):
	value=new_health
