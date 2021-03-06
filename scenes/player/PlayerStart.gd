extends Position3D


enum Balls {FIREBALL, GOLDBALL, CABBAGE}
enum Frames {DEFAULT, ROUND, JET, GARDEN}

export(Balls) var ball = Balls.GOLDBALL
export(Frames) var frame = Frames.DEFAULT

var goldball_scn = load("res://scenes/player/balls/GoldPlayer.tscn")
var fireball_scn = load("res://scenes/player/balls/FirePlayer.tscn")
var cabbage_scn = load("res://scenes/player/balls/CabbagePlayer.tscn")
#var roundframe_scn = load("res://scenes/player/weapons/RoundCage.tscn")
#var jetframe_scn = load("res://scenes/player/weapons/JetCage.tscn")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_player()
	_match_ball()


func _set_player():
	match GameData.current_player:
		1:
			ball = Balls.FIREBALL
		2:
			ball = Balls.GOLDBALL
		3:
			ball = Balls.CABBAGE
		null:
			pass

func _match_cage(player):
	match frame:
		Frames.DEFAULT:
			_match_default(player)
		Frames.JET:
			player.type = player.Cages.JET
		Frames.ROUND:
			player.type = player.Cages.ROUND
		Frames.GARDEN:
			player.type = player.Cages.GARDEN
		


func _match_default(object):
	match ball:
		Balls.FIREBALL:
			object.type = object.Cages.JET
		Balls.GOLDBALL:
			object.type = object.Cages.ROUND
		Balls.CABBAGE:
			object.type = object.Cages.GARDEN


func _match_ball():
	var b
	match ball:
		Balls.FIREBALL:
			b = fireball_scn.instance()
		Balls.GOLDBALL:
			b = goldball_scn.instance()
		Balls.CABBAGE:
			b = cabbage_scn.instance()
	get_parent().call_deferred("add_child", b)
	get_parent().player = b
	b.translation = translation
	b.start_rot = rotation_degrees
	_match_cage(b)

