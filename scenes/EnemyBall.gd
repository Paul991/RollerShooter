extends RigidBody


signal health_updated(health)

onready var Player = get_parent().get_parent().player

export var max_health = 100

var saw_scene = load("res://scenes/enemies/Saw.tscn")
var saw

var cursor_pos = Vector3.ZERO

var speed = 10
var health = max_health setget _set_health


func _ready() -> void:
	add_saw()


func _physics_process(delta):
	if Player != null:
		var dir = get_2d_dir(global_transform.origin, Player.global_transform.origin)
		
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))
	if saw != null:
		saw.translation = translation



func add_saw():
	var s = saw_scene.instance()
	get_parent().call_deferred("add_child", s)
	saw = s
	saw.parent = self


func get_2d_dir(from, to):

	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir

func _death():
	saw.queue_free()
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			_death()
	
	
