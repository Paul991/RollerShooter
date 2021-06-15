extends Spatial


onready var gamecues = $GameCues/AnimationPlayer
onready var enemies = get_tree().get_nodes_in_group("Enemy").size() 


export var timer = 0



var victory = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecues.play("start_game")
	gamecues.queue("start")




func _process(delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy").size()
	
	if enemies == 0 and !victory:
		victory = true
		gamecues.play("game_won")

