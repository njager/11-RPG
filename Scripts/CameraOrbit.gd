extends Spatial

#look stats
var lookSensitivity : float = 15.0
var minLookAngle : float = -20.0
var maxLookAngle : float = 75.0
#vectors
var mouseDelta = Vector2()
#components
onready var player = get_parent()

func _input(event):
	#set mouseDelta when we move our mouse
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	#apply rotation to camera and player
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	#camera vertical rotation
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	#player horizontal rotation
	player.rotation_degrees.y -= rot.y
	
	#clear mouse movement vector
	mouseDelta = Vector2()

func _ready():
	#hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
