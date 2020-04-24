extends KinematicBody

#stats
var curHp : int = 3
var maxHp : int = 3
var damage : int = 1
var attackDist : float = 1.5
var attackRate : float = 1.0

var moveSpeed : float = 2.5

var vel : Vector3 = Vector3()

#components
onready var timer = get_node("Timer")
onready var player = get_node("/root/MainScene/Player")

func _ready():
	#set timer wait time
	timer.wait_time = attackRate
	timer.start()

func _on_Timer_timeout():
	if translation.distance_to(player.translation) <= attackDist:
		player.take_damage(damage)

func _physics_process(delta):
	
	var dist = translation.distance_to(player.translation)
	if dist > attackDist:
		var dir = (player.translation - translation).normalized()
		vel.x = dir.x
		vel.y = 0
		vel.z = dir.z
		
		vel = move_and_slide(vel, Vector3.UP)

func take_damage(damageToTake):
	curHp -= damageToTake
	if curHp <= 0:
		die()
		
func die():
	queue_free()
