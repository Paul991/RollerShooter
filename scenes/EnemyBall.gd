extends RigidBody


signal health_updated(health)

onready var Player = get_parent().get_parent().get_node("Player")

export var max_health = 100

var cursor_pos = Vector3.ZERO

var speed = 10
var health = max_health setget _set_health


func _physics_process(delta):
	var dir = get_2d_dir()

	apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))



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
	
	
