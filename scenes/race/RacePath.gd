extends Path


onready var rng = RandomNumberGenerator.new()

var patrol_path
var patrol_points
var patrol_index = 0

var sawey_scene = preload("res://scenes/enemies/EnemyRaceBall.tscn")
var spikey_scene = preload("res://scenes/enemies/RaceBallSimple.tscn")

export var skip = 5


func _ready() -> void:
	rng.randomize()
	_get_data()
	for i in range(0, patrol_points.size(), skip):
		if patrol_index < patrol_points.size():
		
			var target = patrol_points[patrol_index]
			target.y += translation.y
			if rng.randf() < 0.5:
				add_object(spikey_scene, target)
			else:
				add_object(sawey_scene, target)
			patrol_index += skip
	
	
	
func _get_data():
	patrol_points = curve.get_baked_points() # make it choose a point and start there
	
	
func add_object(object, pos):
	var s = object.instance()
	get_parent().get_node("Enemies").call_deferred("add_child", s)
	s.global_transform.origin = pos
	s.patrol_index = patrol_index
	s.patrol_start = patrol_index
	s.start_pos = pos
