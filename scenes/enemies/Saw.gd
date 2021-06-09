extends CSGMesh


var parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if parent != null:
		translation = parent.translation
		rotation_degrees.y -= 20
