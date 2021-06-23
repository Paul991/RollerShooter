extends RigidBody


signal health_updated(health)

var patrol_path
var patrol_points
var patrol_index = 0

export var max_health = 100

var saw_scene = load("res://scenes/enemies/Saw.tscn")
var saw

var cursor_pos = Vector3.ZERO

var speed = 100
var health = max_health setget _set_health


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	patrol_path = get_parent().get_parent().path
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points() # make it choose a point and start there
	call_deferred("add_saw")


func _physics_process(delta):
	if patrol_path != null:
		var target = patrol_points[patrol_index]
		var dir = get_2d_dir(global_transform.origin, target)
		if translation.distance_to(target) < 30:
			patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
			print(patrol_points.size())
			target = patrol_points[patrol_index]
			print("Patrol index: %s" % patrol_index)
		
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))




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
	
	
