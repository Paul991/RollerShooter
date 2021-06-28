extends RigidBody


signal health_updated(health)

var patrol_path
var patrol_points
var patrol_index = 0
var patrol_start

export var max_health = 100

var saw_scene = load("res://scenes/enemies/Saw.tscn")
var saw

var speed = 20
var health = max_health setget _set_health
var start_pos
var respawn = false
var waiting  = false



func _ready() -> void:
	yield(get_tree(), "idle_frame")
	patrol_path = get_parent().get_parent().path
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points() # make it choose a point and start there
	call_deferred("add_saw")


func _physics_process(delta):
	if patrol_path != null and $RespawnTime.is_stopped():
		var target = patrol_points[patrol_index]
		var dir = get_2d_dir(global_transform.origin, target)
		var dist = get_distance_2d(translation, target)
		if dist < 70:
			patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
#			print(patrol_points.size())
			target = patrol_points[patrol_index]
#			print("Patrol index: %s" % patrol_index)
		
		apply_central_impulse(Vector3(speed*dir.x, 0 , speed*dir.y))


func _integrate_forces(state):
	if respawn:
		var t = state.get_transform()   
		t.origin = start_pos
		respawn = false
		visible = true
		state.set_transform(t)
	if waiting:
		var t = state.get_transform()   
		t.origin = Vector3(start_pos.x, start_pos.y-1000, start_pos.z)
		waiting = false
		state.set_transform(t)
		set_sleeping(true)


func get_distance_2d(a, b):
	a.y = 0
	b.y = 0
	return a.distance_to(b)


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
	var main = get_parent().get_parent()
	main.gamecues.change_time(1)
	$RespawnTime.start()
	waiting = true
	patrol_index = patrol_start
	visible = false

#	saw.queue_free()
#
#	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			_death()
	
	


func _on_RespawnTime_timeout() -> void:
	var player = get_parent().get_parent().player
	if get_distance_2d(start_pos, player.translation) > 500:
		_set_health(max_health)
		respawn = true
	else:
		$RespawnTime.start()
