extends RigidBody


onready var camera = get_parent().get_node("CameraPos/Camera")
onready var camera_pos = get_parent().get_node("CameraPos")
onready var Pointer = get_parent().get_node("Pointer")

var bullet_scene = preload("res://scenes/player/Bullet.tscn")
var cursor_pos = Vector3.ZERO

var speed = 15

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	Pointer.translation = global_transform.origin
	var dir = get_2d_dir()


	if Input.get_action_strength("move") > 0:
		camera_pos.rotation.y = lerp(camera_pos.rotation.y, Pointer.rotation.y, 0.02)
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))
	if Input.is_action_pressed("shoot") and $BulletCooldown.is_stopped():
		add_bullet(dir)


func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		Pointer.rotation.y += -deg2rad(movement.x*0.5)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func add_bullet(dir):
	var b = bullet_scene.instance()
	$BulletCooldown.start()
	get_parent().add_child(b)
	b.global_transform.origin = Pointer.Pos.global_transform.origin
	b.rotation.y = Pointer.rotation.y
	b.shoot = true
	$Sfx/Shoot.play()
#	b.apply_central_impulse(Vector3(b.SPEED*dir.x, 0, b.SPEED*dir.y))

func get_2d_dir():
	var main = Pointer.global_transform.origin
	var point = Pointer.Point.global_transform.origin
	var dir = Vector2.ZERO
	
	main = Vector2(main.x, main.z)
	point = Vector2(point.x, point.z)
	dir = main.direction_to(point)
	return dir
