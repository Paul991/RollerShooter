extends Spatial


enum Enemies {SPIKEY, SAWEY, RANDOM}

onready var tip = get_node("Tip")
onready var rng = RandomNumberGenerator.new()

var spikey_scene = preload("res://scenes/enemies/EnemyBallSimple.tscn")
var sawey_scene = preload("res://scenes/enemies/EnemyBall.tscn")


export var enemy_amount = 100
export(Enemies) var enemy = Enemies.SAWEY
export(float) var rate_time = 0.2


var current_enemy = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	$SpawnRate.set_wait_time(rate_time)



func _process(delta: float) -> void:
	rotation_degrees.y += 2
	
	
#var dir = get_2d_dir(body.global_transform.origin, global_transform.origin)
#		parent.apply_impulse(body.global_transform.origin, Vector3(dir.x*50, 0, dir.y*50))

func _match_enemy(type):
	var e
	match type:
		Enemies.SAWEY:
			e = sawey_scene.instance()
		Enemies.SPIKEY:
			e = spikey_scene.instance()
		Enemies.RANDOM:
			if rng.randf() > 0.5:
				e = sawey_scene.instance()
			else:
				e = spikey_scene.instance()
	return e


func _spawn_enemy():
	var dir = get_2d_dir(global_transform.origin, tip.global_transform.origin)
	var e = _match_enemy(enemy)
	get_parent().get_node("Enemies").call_deferred("add_child", e)
	e.translation = tip.global_transform.origin

	e.apply_impulse(global_transform.origin, Vector3(500*dir.x, 0, 500*dir.y))
	print(e.translation)

func get_2d_dir(from, to):
	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir


func _on_SpawnRate_timeout() -> void:
	if current_enemy < enemy_amount:
		_spawn_enemy()
		current_enemy += 1
