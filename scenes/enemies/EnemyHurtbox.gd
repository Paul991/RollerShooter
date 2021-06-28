extends Area


onready var parent = get_parent()

var impulse = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_2d_dir(from, to):

	var dir = Vector2.ZERO
	
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	dir = from.direction_to(to)
	return dir


func _on_Hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("Saws"): # not really doing it
		var dir = get_2d_dir(body.global_transform.origin, global_transform.origin)
		parent.apply_impulse(body.global_transform.origin, Vector3(dir.x*impulse, 0, dir.y*impulse))
