extends Position3D




var offset
onready var Player = get_parent().get_node("Player")
onready var Pointer = get_parent().get_node("Pointer")
onready var camera = $Camera

var move_vector = Vector3.ZERO
var cursor_pos = Vector3.ZERO


# Called when the node enters the scene tree for the first time.


func _physics_process(delta):

	translation = Player.translation
#	look_at_cursor()




#func look_at_cursor(): follows the mouse 
#	var player_pos = global_transform.origin
#	var drop_plane = Plane(Vector3(0,1,0), player_pos.y)
#	var ray_lenght = 10000
#	var mouse_pos = get_viewport().get_mouse_position()
#	var from = camera.project_ray_origin(mouse_pos) # have to check if the resul is same if plane is tilted
#	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
#	cursor_pos = drop_plane.intersects_ray(from, to)
##	print(cursor_pos)
##	print(get_2d_dir())
#
#	Pointer.look_at(cursor_pos, Vector3.UP)
