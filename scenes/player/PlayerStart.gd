extends Position3D


enum Balls {GOLDBALL, FIREBALL}
enum Frames {DEFAULT, ROUND, JET}

export(Balls) var ball = Balls.GOLDBALL
export(Frames) var frame = Frames.DEFAULT

var goldball_scn = load("res://scenes/player/balls/GoldPlayer.tscn")
var fireball_scn = load("res://scenes/player/balls/FirePlayer.tscn")
#var roundframe_scn = load("res://scenes/player/weapons/RoundCage.tscn")
#var jetframe_scn = load("res://scenes/player/weapons/JetCage.tscn")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_match_ball()


func _match_cage(player):
	match frame:
		Frames.DEFAULT:
			_match_default(player)
		Frames.JET:
			player.type = player.Cages.JET
		Frames.ROUND:
			player.type = player.Cages.ROUND
		


func _match_default(object):
	match ball:
		Balls.FIREBALL:
			object.type = object.Cages.JET
		Balls.GOLDBALL:
			object.type = object.Cages.ROUND


func _match_ball():
	var b
	match ball:
		Balls.FIREBALL:
			b = fireball_scn.instance()

			
		Balls.GOLDBALL:
			b = goldball_scn.instance()
	get_parent().call_deferred("add_child", b)
	b.translation = global_transform.origin
	_match_cage(b)
	get_parent().player = b
