extends RigidBody


signal health_updated(health)

onready var camera = get_parent().get_node("CameraPos/Camera")
onready var camera_pos = get_parent().get_node("CameraPos")
onready var Pointer = get_parent().get_node("Pointer")


var cursor_pos = Vector3.ZERO

var speed = 15
var max_health = 300
var health = max_health setget _set_health
var hurt = false
var start_pos

func _ready():
	start_pos = translation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
##	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
#	print("Pointer rotaion: %s"%Pointer.rotation_degrees.y)
	
	var dir = get_2d_dir(Pointer.global_transform.origin, Pointer.Pos.global_transform.origin)


	if Input.get_action_strength("move") > 0:
		camera_pos.rotation_degrees.y = lerp(camera_pos.rotation_degrees.y, Pointer.rotation_degrees.y, 0.02)
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))
	if Input.is_action_pressed("shoot") and $BulletCooldown.is_stopped():
		$BulletCooldown.start()
		Pointer.add_bullet(dir)
		$Sfx/Shoot.play()


func _input(event):
	if event is InputEventMouseMotion: #make detection for wall edges
		
		var movement = event.relative
		var screen = get_viewport().size
		

		Pointer.rotation_degrees.y += -movement.x*0.5 
		yield(get_tree(), "idle_frame")
		while Pointer.rotation_degrees.y >= 360: # camera is a little weird when this happens
			Pointer.rotation_degrees.y -= 360

		while Pointer.rotation_degrees.y <= -360:
			Pointer.rotation_degrees.y += 360

		print(movement)
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func get_2d_dir(from, to):

	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir


func death():
	_set_health(max_health)
	translation = start_pos


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			death()


func damage(value):
	if !hurt:
		$HurtBox/InvTimer.start()
		hurt = true
		_set_health(health - value)
		

func _on_HurtBox_body_entered(body: Node) -> void:
	if body.is_in_group("Saws"): # not really doing it
		damage(50)
		var dir = get_2d_dir(body.global_transform.origin, global_transform.origin)
		apply_impulse(body.global_transform.origin, Vector3(dir.x, 0, dir.y)*100)


func _on_InvTimer_timeout() -> void:
	hurt = false
