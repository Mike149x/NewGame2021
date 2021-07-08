extends KinematicBody

onready var camera = get_parent().get_node("Camera")

export var max_speed = 10
export var friction = 10
export var speed = 1

var move_vector = Vector3.ZERO
var cursor_pos = Vector3.ZERO



func get_input():
	var input Vector3(
		
		
	)

func _process(delta):
	pass

func _physics_process(delta):
	var input = get_input()
	
