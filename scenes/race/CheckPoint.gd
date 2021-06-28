extends Area


onready var parent = get_parent().get_parent() # yep...

export(int) var id = 1 # 1 is startline
export(int) var time_bonus = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_CheckPoint_body_entered(body: Node) -> void:
	var player = parent.main.player
	print(id, parent.gate_count, parent.last_gate)
	if parent.last_gate == null:
		parent.last_gate = id
	if parent.last_gate == parent.gate_count and id == 1:
		parent.last_gate = id
		parent.main.gamecues.change_time(time_bonus)
		if parent.lap < parent.laps:
			parent.set_label(parent.lap+1, parent.laps)
		else:
			parent.main.victory = true
			
	if id != 1:
		if parent.last_gate != id:
			parent.last_gate = id
			print(parent.last_gate)
			parent.main.gamecues.change_time(time_bonus)
	player.start_pos = translation
	player.start_rot = rotation_degrees

	print(id, parent.gate_count, parent.last_gate)
