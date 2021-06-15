extends RayCast

onready var parent = get_parent()
onready var normal = global_transform.basis


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _process(delta: float) -> void:
	if is_colliding():
		var r = parent.rotation_degrees.y
		var n = self.get_collision_normal()
		var xform = align_with_y(parent.global_transform, n)
		parent.global_transform = parent.global_transform.interpolate_with(xform, 0.2)
		parent.rotation_degrees.y = r
		global_transform.basis = normal
		

