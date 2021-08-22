extends KinematicBody

onready var camera = get_parent().get_node("Camera")
onready var tracer = preload("res://Scenes/TracerFire.tscn")
onready var case = preload("res://Scenes/BulletCase.tscn")

export var max_speed = 10
export var friction = 10
export var speed = 1
export var acceleration = 0.1

var move_vector = Vector3.ZERO
var cursor_pos = Vector3.ZERO
var can_fire = true

func look_at_cursor():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) *ray_length
	cursor_pos = drop_plane.intersects_ray(from, to)
	#print(cursor_pos)
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
	if Input.is_action_pressed("player_fire") and can_fire:
		can_fire = false
		var new_case = case.instance()
		new_case.global_transform = $CaseEjector.global_transform
		get_parent().add_child(new_case)
		
		#add tracer fire
		var new_tracer = tracer.instance()
		new_tracer.global_transform = $EndOfChainGun.global_transform
		get_parent().add_child(new_tracer)
		
		#change timer
		$ChainGunTimer.set_wait_time($ChainGunTimer.get_wait_time() - 0.05)
		$ChainGunTimer.start()
	if not Input.is_action_pressed("player_fire"):
		$ChainGunTimer.set_wait_time($ChainGunTimer.get_wait_time() + 0.1)
		if $ChainGunTimer.get_wait_time() > 0.3:
			$ChainGunTimer.set_wait_time(0.3)

func _physics_process(delta):
	var input = get_input()
	if input != Vector3.ZERO:
		speed += acceleration
		if speed > max_speed:
			speed = max_speed
	else:
		speed -= acceleration
		if speed < 0:
			speed = 0
	#print(speed)
	
	move_vector = input * speed
	if move_vector != Vector3.ZERO:
		$MainCharacter/AnimationPlayer.play("Run")
	else:
		$MainCharacter/AnimationPlayer.play("Idle")
	move_and_slide(move_vector)

	look_at_cursor()



func _on_ChainGunTimer_timeout():
	can_fire = true
