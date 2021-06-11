extends RigidBody


signal health_updated(health)
signal max_health_updated(max_health)

onready var camera = get_parent().get_node("CameraPos/Camera")
onready var camera_pos = get_parent().get_node("CameraPos")
onready var Pointer = get_parent().get_node("Pointer")



var cursor_pos = Vector3.ZERO

var speed = 15
var health = max_health setget _set_health
var hurt = false
var respawn = false
var start_pos

export(int) var max_health setget _set_max_health

func _ready():
	_set_max_health(max_health)
	start_pos = translation
	print(start_pos)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
##	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
#	print("Pointer rotaion: %s"%Pointer.rotation_degrees.y)
	
	var dir = get_2d_dir(Pointer.global_transform.origin, Pointer.Pos.global_transform.origin)
	if Input.get_action_strength("move") > 0:
		print(camera_pos.rotation_degrees.y)
#		camera_pos.rotation_degrees.y = lerp(camera_pos.rotation_degrees.y, Pointer.rotation_degrees.y, 0.02)
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))
	if Input.is_action_pressed("shoot") and $BulletCooldown.is_stopped():
		$BulletCooldown.start()
		Pointer.add_bullet(dir)
		$Sfx/Shoot.play()
	camera_pos.rotation_degrees.y = lerp(camera_pos.rotation_degrees.y, Pointer.rotation_degrees.y, 0.05)


func _input(event):
	if event is InputEventMouseMotion: #make detection for wall edges
		
		var movement = event.relative
		var screen = get_viewport().size
#		if Input.get_action_strength("move") == 0:
#			while camera_pos.rotation_degrees.y >= 360: # camera is a little weird when this happens
#				camera_pos.rotation_degrees.y -= 360
#			while camera_pos.rotation_degrees.y <= -360:
#				camera_pos.rotation_degrees.y += 360
#			while Pointer.rotation_degrees.y >= 360: # camera is a little weird when this happens
#				Pointer.rotation_degrees.y -= 360
#			while Pointer.rotation_degrees.y <= -360:
#				Pointer.rotation_degrees.y += 360
		

		Pointer.rotation_degrees.y += -movement.x*0.2

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _integrate_forces(state):
	if respawn:
		var t = state.get_transform()   
		t.origin = start_pos
		respawn = false
		state.set_transform(t)


func get_2d_dir(from, to):

	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir


func death():
	print("dead")
	_set_health(max_health)
	respawn = true
#	translation = start_pos


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			death()


func _set_max_health(value):
	var prev_max_health = max_health
	max_health = value
#	if max_health != prev_max_health:
	emit_signal("max_health_updated", health)
	_set_health(max_health)


