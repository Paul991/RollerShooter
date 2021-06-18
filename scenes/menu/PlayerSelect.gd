extends Spatial

signal changed_selection(selected)


onready var camera = get_node("Camera")
onready var buttons = get_node("CanvasLayer/Buttons")
onready var prev = get_node("CanvasLayer/Buttons/Prev")
onready var next = get_node("CanvasLayer/Buttons/Next")

var level_path = preload("res://scenes/Main.tscn")

var players
var selected setget _set_selection
var start_pos
var destination
var moving = false


export var move_amount = Vector3(100, 0, 0)



func _ready() -> void:
	players = get_node("Players").get_child_count()
	print(players)
	start_pos = camera.translation
	_set_selection(1)
	
	


func _process(delta: float) -> void:
	button_focus()
	if moving:
		move_camera()


func button_disable():
	if selected == 1:
		prev.set_disabled(true)
		prev.release_focus()
	else:
		prev.set_disabled(false)
		
	if selected == players:
		next.set_disabled(true)
		next.release_focus()
	else:
		next.set_disabled(false)


func button_focus():
	for button in buttons.get_children():
		if button.is_hovered() and button.disabled == false:
			button.grab_focus()


func _set_selection(value):
	var prev_value = value

	if prev_value != selected:
		selected = value
		emit_signal("changed_selection", selected)


func move_camera():
	if camera.translation != destination:
		camera.translation = camera.translation.linear_interpolate(destination, 0.1)
	if camera.translation.x > destination.x-0.5 and camera.translation.x < destination.x+0.5:
		camera.translation = destination
		moving = false
		print("stopped")
	


func _on_Next_pressed() -> void:
	if selected != players:
		_set_selection(selected + 1)
		destination = camera.translation - move_amount
		moving = true
		button_disable()


func _on_Prev_pressed() -> void:
	if selected != 1:
		_set_selection(selected - 1)
		destination = camera.translation + move_amount
		moving = true
		button_disable()


func _on_Start_pressed() -> void:
	GameData.current_player = selected
	get_tree().change_scene_to(level_path)

