extends RigidBody


enum Cages {ROUND, JET}



signal health_updated(health)
signal max_health_updated(max_health)

onready var camera = get_parent().get_node("CameraPos/Camera")
onready var camera_pos = get_parent().get_node("CameraPos")
onready var round_scene = preload("res://scenes/player/weapons/RoundCage.tscn")
onready var point_scene = preload("res://scenes/player/weapons/JetCage.tscn")



var cursor_pos = Vector3.ZERO


var health = max_health setget _set_health
var grounded = false
var dead = true
var hurt = false
var respawn = false
var Cage = null
var start_pos

export var speed = 15
export(int) var max_health setget _set_max_health
var type = Cages.JET

func _ready():
#	get_parent().player = self
	_spawn_cage()
	_set_max_health(max_health)
	start_pos = translation

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
##	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if Cage != null and !get_parent().defeat: # gotta make a autoload for the gamestates
		var plane_speed = Vector2(linear_velocity.x, linear_velocity.z)
		var dir = get_2d_dir(Cage.global_transform.origin, Cage.Pos.global_transform.origin)
		_engine_sound(get_speed(plane_speed))
		if Input.get_action_strength("move") > 0 and grounded:

	#		camera_pos.rotation_degrees.y = lerp(camera_pos.rotation_degrees.y, Pointer.rotation_degrees.y, 0.02)
			apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))

		if Input.is_action_pressed("shoot") and $BulletCooldown.is_stopped():
			$BulletCooldown.start()
			Cage.add_bullet(dir)
			$Sfx/Shoot.play()
			
		camera_pos.rotation_degrees.y = lerp(camera_pos.rotation_degrees.y, Cage.rotation_degrees.y, 0.05)




func _input(event):
	if event is InputEventMouseMotion: #make detection for wall edges
		
		var movement = event.relative
		var screen = get_viewport().size

		if Cage != null:
			Cage.rotation_degrees.y += -movement.x*0.2

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _spawn_cage():
	var a
	match type:
		Cages.JET:
			$BulletCooldown.set_wait_time(0.15)
			a = point_scene.instance()
		Cages.ROUND:
			$BulletCooldown.set_wait_time(0.07)
			a = round_scene.instance()
	print(a.name)
	get_parent().call_deferred("add_child", a)
	yield(get_tree(), "idle_frame")
	Cage = a

func _integrate_forces(state):
	if respawn:
		var t = state.get_transform()   
		t.origin = start_pos
		respawn = false
		state.set_transform(t)


func get_speed(value: Vector2): # sort of

	if abs(value.x) > abs(value.y):
		return abs(value.x)
	else:
		return abs(value.y)


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


func _engine_sound(value):
	var current_speed = value
	if current_speed > 1:
		$Sfx/Engine.set_pitch_scale(current_speed/100+1.5)
#		print(current_speed)

		if $Sfx/Engine.is_playing() == false:
				$Sfx/Engine.play()
	else:
		$Sfx/Engine.stop() # maybe, maybe not


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


