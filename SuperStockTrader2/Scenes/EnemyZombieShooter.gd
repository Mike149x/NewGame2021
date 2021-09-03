extends KinematicBody


var player
var follow_player = false
var move_speed = 50
var can_shoot = false
onready var bullet = preload("res://Scenes/EnemyBullet.tscn")
var health = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit_zombie():
	health -= 1
	if health <= 0:
		#play animation and yield until finished
		#$SlowZombie/AnimationPlayer.play("Death")
		#yield($SlowZombie/AnimationPlayer, "finished")
		queue_free()

func _physics_process(delta):
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
				
	if can_shoot:
		var new_bullet = bullet.instance()
		new_bullet.global_transform.origin = $Launcher.global_transform.origin
		get_parent().add_child(new_bullet)
		can_shoot = false
		$Timer.start()

func _on_Area_body_entered(body):
	if body.name == "Player":
		$RayCast.set_enabled(true)
		print("found player")
		follow_player = true
		can_shoot = true 
		player = body


func _on_Area_body_exited(body):
	if body.name == "Player":
		$RayCast.set_enabled(false)
		print("lost player")
		follow_player = false
		can_shoot = false



func _on_Timer_timeout():
	can_shoot = true 
	pass # Replace with function body.
