extends Spatial

onready var Player
onready var Left = get_node("Left")
onready var Right = get_node("Right")
onready var Pos = get_node("Pos")
onready var Push = get_node("Push")

var bullet_scene = preload("res://scenes/player/weapons/CarrotBullet.tscn")



func _process(delta: float) -> void:
	if Player != null:
		translation = Player.translation
	if Input.get_action_strength("move") > 0:
		if Push.emitting == false:
			Push.set_emitting(true)
	else:
		Push.set_emitting(false)

func add_bullet(dir):
	var l = bullet_scene.instance()
	var r = bullet_scene.instance()
	get_parent().add_child(l)
	get_parent().add_child(r)
	l.global_transform.origin = Left.global_transform.origin
	l.rotation = rotation

	l.shoot = true
	r.global_transform.origin = Right.global_transform.origin
	r.rotation = rotation
	r.shoot = true
