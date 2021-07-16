extends KinematicBody

onready var camera = get_parent().get_node("Camera")

export var max_speed = 10
export var friction = 10
export var speed = 1
export var acceleration = 0.1

var move_vector = Vector3.ZERO
var cursor_pos = Vector3.ZERO

func look_at_cursor():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) *ray_length
	cursor_pos = drop_plane.intersects_ray(from, to)
	print(cursor_pos)
	look_at(cursor_pos, Vector3.UP)
	

func get_input():
	var input = Vector3(
		-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")),
		0,
		-int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down"))
	)
	input = input.normalized()
	return input

func _process(delta):
	pass

func _physics_process(delta):
	var input = get_input()
	if input != Vector3.ZERO:
		speed += acceleration
		if speed > max_speed:
			speed = max_speed
	
	move_vector = input * speed
	move_and_slide(move_vector)

	look_at_cursor()








