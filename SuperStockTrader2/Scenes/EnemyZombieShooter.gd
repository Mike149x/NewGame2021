extends KinematicBody


var player
var follow_player = false
var move_speed = 50
var can_shoot = false
onready var bullet = preload("res://Scenes/EnemyBullet.tscn")
var health = 4
var ammo_box = preload("res://Scenes/AmmoBox.tscn")
var medkit = preload("res://Scenes/Medkit.tscn")
onready var blood = preload("res://Scenes/BloodSpray.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit_zombie():
	health -= 1
	#health -= PlayerStats.get_gun_damage()
	if health <= 0:
		#On Death - Play Particle Efects and Sound
		SoundPlayer.play("res://Sounds/Explosion_001.wav")
		var b = blood.instance()
		b.global_transform = global_transform
		get_parent().add_child(b)
		b.set_emitting(true)
		
		#Set Drop Rate for Items
		if floor(rand_range(0, 5)) == 0:
			if floor(rand_range(0, 2)) == 0:
				var new_medkit = medkit.instance()
				new_medkit.global_transform = global_transform
				get_parent().add_child(new_medkit)
			else:
				var new_ammo_box = ammo_box.instance()
				new_ammo_box.global_transform = global_transform
				get_parent().add_child(new_ammo_box)
		#play animation and yield until finished
		#$SlowZombie/AnimationPlayer.play("Death")
		#yield($SlowZombie/AnimationPlayer, "finished")
		queue_free()

func _physics_process(delta):
	#Look at Player and back up
	if follow_player == true:
		var pos = player.global_transform.origin
		var facing = -global_transform.basis.z
		look_at(pos, Vector3.UP)
		if $RayCast.get_collider() != null:
			if $RayCast.get_collider().name == "Player":
				move_and_slide(-facing * move_speed * delta, Vector3.UP)
				$ShooterZombie/AnimationPlayer.play("Run")
			else:
				$ShooterZombie/AnimationPlayer.play("Idle")
				
	#Shooting bullets
	if can_shoot:
		var new_bullet = bullet.instance()
		new_bullet.global_transform.origin = $Launcher.global_transform.origin
		get_parent().add_child(new_bullet)
		can_shoot = false
		$Timer.start()

func _on_Area_body_entered(body):
	#Player entering Field of View
	if body.name == "Player":
		$RayCast.set_enabled(true)
		print("found player")
		follow_player = true
		can_shoot = true 
		player = body


func _on_Area_body_exited(body):
	#Player leavng field of view
	if body.name == "Player":
		$RayCast.set_enabled(false)
		print("lost player")
		follow_player = false
		can_shoot = false



func _on_Timer_timeout():
	#Timer, basically fire rate
	can_shoot = true 
	pass # Replace with function body.
