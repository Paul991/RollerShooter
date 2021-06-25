extends CanvasLayer


onready var parent = get_parent()
onready var counter = $Counter
onready var time_left = $TimeLabel
onready var anim_player = $AnimationPlayer

export var time = 60


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	update_timer()
	if parent.victory:
		counter.stop()
		anim_player.queue("game_won")


func update_timer():
	if counter.is_stopped() == false:
		var text = str(int(counter.get_time_left()))
		time_left.text = text


func start_timer():
	counter.set_wait_time(time)
	counter.start()


func change_time(value):
	if !parent.defeat and !parent.victory:
		var current_time = counter.get_time_left()
		var new_time = current_time + value
		counter.stop()
		counter.set_wait_time(new_time)
		counter.start()


func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false


func _on_Counter_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy").size()
	
	if enemies > 0 and !parent.victory:
		parent.defeat = true
		$AnimationPlayer.play("game_lost")
