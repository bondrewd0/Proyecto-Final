extends Sprite2D
class_name  DeviceBase

#Objeto a vincular para des/activar
@export var Attached_Object:Node2D=null
#Si el boton es de un solo uso
@export var One_use:bool=false
#Referencias a nodos internos
@onready var animplayer = $AnimationPlayer
@onready var pressed_sfx = $PressedSFX
#Revisa si ya se realizo la accion
var action_done:bool=false
#Variable para guardar el nombre de la siguiente animacion
var next_anim


# Empieza apagado y la siguiente animacion sera la de encendido
func _ready():
	animplayer.play("Off")
	next_anim="On"

#Logica de cuando se presiona el boton
func interaction():
	#Si se de un solo uso
	#Verifica si ya se uso y salteo o lleva a cabo la accion
	if One_use:
		if action_done:
			pass
		else:
			action()
			action_done=true
	else :
		action()

#Logica de la accion
func action():
	#Ejecuta sonido y cambia de animacion
	pressed_sfx.play()
	print(Attached_Object)
	animplayer.play(next_anim)
	if next_anim=="On":
		next_anim="Off"
	else:
		next_anim="On"
	#Verifica que el otro objeto tenga una accion que pueda realizar y la ejecuta
	if Attached_Object.has_method("action"):
		
		Attached_Object.action()
