extends Spatial



onready var gamecues = $GameCues
onready var enemies = get_tree().get_nodes_in_group("Enemy").size() 
onready var path = get_node("Path")


export var timer = 0
export(bool) var race = false



var defeat = false
var victory = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecues.anim_player.play("start_game")
	gamecues.anim_player.queue("start")
	
	gamecues.anim_player.queue("start_timer")





func _process(delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy").size()
	if !race:
		if enemies == 0 and !victory:
			victory = true


