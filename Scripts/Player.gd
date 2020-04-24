extends KinematicBody

#stats
var curHp : int = 10
var maxHp : int = 10
var damage : int = 1
var gold : int = 0
var attackRate : float = 0.3
var lastAttackTime : int = 0
const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5

#physics
var moveSpeed : float = 5.0
var jumpForce : float = 10.0
var gravity : float = 15.0
var vel = Vector3()

#components
onready var camera = get_node("CameraOrbit")
onready var attackCast = get_node("AttackRayCast")
onready var ui = get_node("CanvasLayer/UI")

func _ready():
	ui.update_health_bar(curHp, maxHp)
	ui.update_gold_text(gold)

func _physics_process(delta):
	
	vel.x = 0
	vel.z = 0
	var input = Vector3()
	var blend = 0
	
	if Input.is_action_pressed("move_forwards"):
		input.z += 1
	if Input.is_action_pressed("move_backwards"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
	
	input = input.normalized()
	
	#get relative direction
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	#apply direction to velocity
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	vel.y -= gravity * delta
	
	#animate player
	var hv = vel
	hv.y = 0
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	var speed = hv.length() / SPEED
	$AnimationTree.set("parameters/Idle_Run/blend_amount",speed)
	
	
	#jump input
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
	#move player
	vel = move_and_slide(vel, Vector3.UP)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		try_attack()

func try_attack():
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
	
	lastAttackTime = OS.get_ticks_msec()
	
	$swordAnimation.stop()
	$swordAnimation.play("Attack_2")
	
	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)
	

func give_gold(amount):
	gold += amount
	ui.update_gold_text(gold)

func take_damage (damageToTake):
	curHp -= damageToTake
	ui.update_health_bar(curHp, maxHp)
	if curHp <= 0:
		die()

func die():
	get_tree().reload_current_scene()
