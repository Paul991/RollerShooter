extends Spatial

enum Amount {ONE, TWO, THREE}


onready var Point = get_node("Point")
onready var Left = get_node("Left")
onready var Right = get_node("Right")
onready var Pos = get_node("Pos")

var bullet_scene = preload("res://scenes/player/Bullet.tscn")


export(Amount) var guns = Amount.ONE



# Called when the node enters the scene tree for the first time.
func _ready():
	set_guns()

func set_guns():
	match guns:
		Amount.ONE:
			Point.visible = true
			Left.visible = false
			Right.visible = false
		Amount.TWO:
			Point.visible = false
			Left.visible = true
			Right.visible = true
		Amount.THREE:
			Point.visible = true
			Left.visible = true
			Right.visible = true


func add_bullet(dir):
	var p
	var l
	var r
	match guns:
		Amount.ONE:
			p = bullet_scene.instance()
			get_parent().add_child(p)
			p.global_transform.origin = Point.global_transform.origin
			p.rotation.y = rotation.y
			p.shoot = true

		Amount.TWO:
			l = bullet_scene.instance()
			r = bullet_scene.instance()
			get_parent().add_child(l)
			get_parent().add_child(r)
			l.global_transform.origin = Left.global_transform.origin
			l.rotation.y = rotation.y
			l.shoot = true
			r.global_transform.origin = Right.global_transform.origin
			r.rotation.y = rotation.y
			r.shoot = true
		Amount.THREE:
			p = bullet_scene.instance()
			l = bullet_scene.instance()
			r = bullet_scene.instance()
			get_parent().add_child(p)
			get_parent().add_child(l)
			get_parent().add_child(r)
			p.global_transform.origin = Point.global_transform.origin
			p.rotation.y = rotation.y
			p.shoot = true
			l.global_transform.origin = Left.global_transform.origin
			l.rotation.y = rotation.y
			l.shoot = true
			r.global_transform.origin = Right.global_transform.origin
			r.rotation.y = rotation.y
			r.shoot = true

