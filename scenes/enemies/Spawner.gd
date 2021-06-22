extends Spatial


enum Enemies {SPIKEY, SAWEY, BULLET, RANDOM}
enum Guns {ONE, TWO, FOUR}

onready var tips = get_node("Tips")
onready var rng = RandomNumberGenerator.new()

var spikey_scene = preload("res://scenes/enemies/EnemyBallSimple.tscn")
var sawey_scene = preload("res://scenes/enemies/EnemyBall.tscn")
var bullet_scene = preload("res://scenes/enemies/EnemyBullet.tscn")


export var enemy_amount = 100
export(Enemies) var enemy = Enemies.SAWEY
export(Guns) var type = Guns.FOUR
export(float) var rate_time = 0.2
export var rotation_speed = 2
export var speed = 200


var current_enemy = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_tips()
	rng.randomize()
	$SpawnRate.set_wait_time(rate_time)



func _process(delta: float) -> void:
	rotation_degrees.y += rotation_speed


func _set_tips():
	match type:
		Guns.ONE:
			$Tips/Tip2.queue_free()
			$Tips/Tip3.queue_free()
			$Tips/Tip4.queue_free()
		Guns.TWO:
			$Tips/Tip2.queue_free()
			$Tips/Tip4.queue_free()


func _match_enemy(type):
	var e
	match type:
		Enemies.SAWEY:
			e = sawey_scene.instance()
		Enemies.SPIKEY:
			e = spikey_scene.instance()
		Enemies.BULLET:
			e = bullet_scene.instance()
		Enemies.RANDOM:
			if rng.randf() > 0.5:
				e = sawey_scene.instance()
			else:
				e = spikey_scene.instance()
	return e


func _spawn_enemy(tip):
	var dir = get_2d_dir(global_transform.origin, tip.global_transform.origin)
	var e = _match_enemy(enemy)
	get_parent().get_node("Enemies").call_deferred("add_child", e)
	e.translation = tip.global_transform.origin
	e.apply_impulse(global_transform.origin, Vector3(speed*dir.x, 0, speed*dir.y))

	print(e.translation)

func get_2d_dir(from, to):
	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir


func _on_SpawnRate_timeout() -> void:
	if current_enemy < enemy_amount:
		for tip in tips.get_children():
			
			_spawn_enemy(tip)
		current_enemy += 1
