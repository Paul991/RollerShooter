extends Area


onready var parent = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func damage(value):
	if !parent.hurt:
		$InvTimer.start()
		parent.hurt = true
		parent.health -= value
		
		

func _on_HurtBox_body_entered(body: Node) -> void:
	if body.is_in_group("Saws"): # not really doing it
		var dir = parent.get_2d_dir(body.global_transform.origin, global_transform.origin)
		parent.apply_impulse(body.global_transform.origin, Vector3(dir.x*20, 0, dir.y*20))
		damage(50)
	if "EnemyBallSimple" in body.name:
		damage(20)

func _on_InvTimer_timeout() -> void:
	parent.hurt = false
