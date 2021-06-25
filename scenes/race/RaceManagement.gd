extends Spatial


onready var gate_count = get_node("Gates").get_child_count()
onready var main = get_parent()
onready var laps_label = get_node("Laps/Label")


export(int) var laps = 3

var lap = 1
var last_gate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("gate count: %s" % gate_count)
	set_label(lap, laps)
	

func set_label(a, x): # lap, laps 
	lap = a
	laps_label.text = str(lap)+"/"+str(laps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
