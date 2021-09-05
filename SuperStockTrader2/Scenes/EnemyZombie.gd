extends KinematicBody


var player
var follow_player = false
var move_speed = 100
var health = 2
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
		var b = blood.instance()
		b.global_transform = global_transform
		get_parent().add_child(b)
		b.set_emitting(true)
		
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
	if follow_player == true:
		var pos = player.global_transform.origin
		var facing = -global_transform.basis.z
		look_at(pos, Vector3.UP)
		if $RayCast.get_collider() != null:
			if $RayCast.get_collider().name == "Player":
				move_and_slide(facing * move_speed * delta, Vector3.UP)
				$SlowZombie/AnimationPlayer.play("Run")
			else:
				$SlowZombie/AnimationPlayer.play("Idle")

func _on_Area_body_entered(body):
	if body.name == "Player":
		$RayCast.set_enabled(true)
		print("found player")
		follow_player = true
		player = body


func _on_Area_body_exited(body):
	if body.name == "Player":
		$RayCast.set_enabled(false)
		print("lost player")
		follow_player = false

