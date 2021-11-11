extends KinematicBody

onready var camera = get_parent().get_node("Camera")
onready var tracer = preload("res://Scenes/TracerFire.tscn")
onready var case = preload("res://Scenes/BulletCase.tscn")
var enemy_list = ["res://Scenes/EnemyZombie.tscn", "res://Scenes/EnemyZombieShooter.tscn", "res://Scenes/EnemySpinningShooter.tscn"]
onready var spark = preload("res://Scenes/Spark.tscn")

export var max_speed = 10
export var friction = 10
export var speed = 1
export var acceleration = 0.1



var move_vector = Vector3.ZERO
var cursor_pos = Vector3.ZERO
var can_fire = true

#character looks at mouse
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
	

 #gets movement input and stores it
func get_input(): 
	var input = Vector3(
		-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")),
		0,
		-int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down"))
	)
	input = input.normalized()
	return input

#this is the function that gets called to see if player shoots an enemy
#Checks to see if bullet is colliding with the 3 enemy types
func check_hit(): 
	if $HitScan.is_colliding():
		print($HitScan.get_collider().filename)
		if $HitScan.get_collider().filename == "res://Scenes/EnemyZombieShooter.tscn":
			$HitScan.get_collider().hit_zombie()
		elif $HitScan.get_collider().filename == "res://Scenes/EnemyZombie.tscn":
			$HitScan.get_collider().hit_zombie()
		elif $HitScan.get_collider().filename == "res://Scenes/EnemySpinningShooter.tscn":
			$HitScan.get_collider().hit_zombie()
			
		else:
			var s = spark.instance()
			s.global_transform.origin = $HitScan.get_collision_point()
			s.set_emitting(true)
			get_parent().add_child(s)
		

#Shooting
func _process(delta):  
	#On M1 Click - checks to see if can fire
	if Input.is_action_pressed("player_fire") and can_fire and PlayerStats.has_ammo():
		PlayerStats.change_ammo(-1)
		check_hit()
		#Spawns ammo casing after every shot
		can_fire = false 
		var new_case = case.instance()
		new_case.global_transform = $CaseEjector.global_transform
		get_parent().add_child(new_case)
		
		#add tracer fire - the actual hitscan bullet
		var new_tracer = tracer.instance()
		new_tracer.global_transform = $EndOfChainGun.global_transform
		get_parent().add_child(new_tracer)
		
		#change timer - this dictates the fire rate
		if $ChainGunTimer.get_wait_time() > 0.1:
			$ChainGunTimer.set_wait_time($ChainGunTimer.get_wait_time() - 0.05)
		$ChainGunTimer.start()
	if not Input.is_action_pressed("player_fire"):
		$ChainGunTimer.set_wait_time($ChainGunTimer.get_wait_time() + 0.1)
		if $ChainGunTimer.get_wait_time() > 0.3:
			$ChainGunTimer.set_wait_time(0.3)
		
	#if player dies resets level
	if PlayerStats.get_health() <= 0: 
		get_tree().reload_current_scene()
		PlayerStats.change_lives(-1)
		PlayerStats.reset()

func _physics_process(delta):
	#The player has to gain momentum
	var input = get_input()
	if input != Vector3.ZERO:
		speed += acceleration
		if speed > max_speed:
			speed = max_speed
	
	#This part means everytime the player stops, he loses momentum....
	#makes game too slow

	#else:
		#speed -= acceleration
		#if speed < 0:
			#speed = 0
	#print(speed)
	
	#Plays the 2 animations when player is walking, or just standing
	move_vector = input * speed
	if move_vector != Vector3.ZERO:
		$MainCharacter/AnimationPlayer.play("Run")
	else:
		$MainCharacter/AnimationPlayer.play("Idle")
	move_and_slide(move_vector)

	look_at_cursor()



func _on_ChainGunTimer_timeout():
	can_fire = true


func _on_Area_area_entered(area ):
	#If player gets hit by projectile
	if area.get_parent().filename == "res://Scenes/EnemyBullet.tscn":
		#projectiles do 5 damge
		PlayerStats.change_health(-5)
		SoundPlayer.play("res://Sounds/001.wav")
		area.get_parent().queue_free()


func _on_Area_body_entered(body):
	#If player gets touched by various things, whie not invulnerable
	if body.filename in enemy_list and $InvulnerabilityFrames.is_stopped():
		$InvulnerabilityFrames.start()
		PlayerStats.change_health(-50)
		#50 dmg from melee damge
		SoundPlayer.play("res://Sounds/001.wav")
	if body.filename == "res://Scenes/Medkit.tscn":
		SoundPlayer.play("res://Sounds/Jump_002.wav")
		PlayerStats.change_health(15)
		#medkit heals 15hp
		body.queue_free()
	if body.filename == "res://Scenes/AmmoBox.tscn":
		SoundPlayer.play("res://Sounds/Jump_004.wav")
		PlayerStats.change_ammo(25)
		#ammo box gives 25 ammo
		body.queue_free()




