extends Particles


var life

func _ready():
	life = lifetime
	$Impact.play()


func _process(delta):
	life -= delta
	if life < 0:
		print("Particle death")
		queue_free()
