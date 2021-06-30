extends HBoxContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _get_stats(choice): # Speed, weight, rate, dmg
	var s = []
	match choice:
		1:
			s = [50, 70, 40, 70]
		2:
			s = [80, 40, 60, 30]
		3:
			s = [30, 25, 80, 50]
	return s


func _on_PlayerSelect_changed_selection(selected) -> void:
	var stats = _get_stats(selected)
	$VBox/Speed.value = stats[0]
	$VBox/Weight.value = stats[1]
	$VBox/Firerate.value = stats[2]
	$VBox/Damage.value = stats[3]
