extends CSGMesh


var parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(1), "timeout")
	set_collision_layer_bit(2, true)


func _process(delta: float) -> void:
	if parent != null:

		rotation_degrees.y -= 20
