extends RigidBody

const DAMAGE = 50
const SPEED = 30


var explosion_scene = load("res://scenes/shaders&particles/ExplosionParticle.tscn")
var shoot = false

func ready():
	set_as_toplevel(true)


func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_inpact():
	
	var e = explosion_scene.instance()
	get_parent().add_child(e)
	e.global_transform.origin = global_transform.origin
	e.set_emitting(true)
	yield(get_tree(), "idle_frame")
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		_on_inpact()
	else:
		queue_free()
