extends Spatial

enum Amount {ONE, TWO, THREE}


onready var Player = get_parent().player
onready var Point = get_node("Point")
onready var Left = get_node("Left")
onready var Right = get_node("Right")
onready var Pos = get_node("Pos")
onready var Push = get_node("Push")

var bullet_scene = preload("res://scenes/player/weapons/RectangularBullet.tscn")


export(Amount) var guns = Amount.THREE



# Called when the node enters the scene tree for the first time.
func _ready():
	set_guns()


func _process(delta: float) -> void:
	translation = Player.translation
	if Input.get_action_strength("move") > 0:
		if Push.emitting == false:
			Push.set_emitting(true)
	else:
		Push.set_emitting(false)

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
			p.rotation.y = rotation
			p.shoot = true

		Amount.TWO:
			l = bullet_scene.instance()
			r = bullet_scene.instance()
			get_parent().add_child(l)
			get_parent().add_child(r)
			l.global_transform.origin = Left.global_transform.origin
			l.rotation = rotation

			l.shoot = true
			r.global_transform.origin = Right.global_transform.origin
			r.rotation = rotation
			r.shoot = true
		Amount.THREE:
			p = bullet_scene.instance()
			l = bullet_scene.instance()
			r = bullet_scene.instance()
			get_parent().add_child(p)
			get_parent().add_child(l)
			get_parent().add_child(r)
			p.global_transform.origin = Point.global_transform.origin
			p.rotation = rotation
			p.shoot = true
			l.global_transform.origin = Left.global_transform.origin
			l.rotation = rotation
			l.shoot = true
			r.global_transform.origin = Right.global_transform.origin
			r.rotation = rotation
			r.shoot = true

