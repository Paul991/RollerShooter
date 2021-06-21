extends RigidBody


signal health_updated(health)

onready var Player = get_parent().get_parent().player
onready var timer = $Timer

export var max_health = 100

var move_vector = Vector2.ZERO
var cursor_pos = Vector3.ZERO
var health = max_health setget _set_health
var speed = 20
var rng = RandomNumberGenerator.new()

# make them explode at start (maybe this enemies are bombs)
# give random collision at start, and change direction with collision(mayb better donw with kinematic)

func ready():
	rng.randomize()
	move_vector = get_2d_dir()


func _physics_process(delta):
	apply_central_impulse(Vector3(speed*move_vector.x,0 ,speed*move_vector.y))

func random_dir():
	var num = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1))
	return num



func get_2d_dir():
	var main = global_transform.origin
	var point = Player.global_transform.origin
	var dir = Vector2.ZERO
	
	main = Vector2(main.x, main.z)
	point = Vector2(point.x, point.z)
	dir = main.direction_to(point)
	return dir


func _death():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			_death()


func _on_Timer_timeout():
	rng.randomize()
	timer.set_wait_time(rng.randf_range(2,4))

	if rng.randf() > 0.6:
		move_vector = random_dir()
	else:
		move_vector = get_2d_dir()
	timer.start()
