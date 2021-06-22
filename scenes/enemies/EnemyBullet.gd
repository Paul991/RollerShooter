extends RigidBody

const DAMAGE = 20
const SPEED = 200


var explosion_scene = load("res://scenes/shaders&particles/BlueExplosionParticle.tscn")
var direction

func ready():
	set_as_toplevel(true)



#func _physics_process(delta):
#
#	apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_inpact():
	var e = explosion_scene.instance()
	get_parent().add_child(e)
	e.global_transform.origin = global_transform.origin
	e.set_emitting(true)
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= DAMAGE
		queue_free()
	elif body.is_in_group("Bullets"):
		_on_inpact()
	else:
		queue_free()


func _on_DeleteTimer_timeout() -> void:
	queue_free()
