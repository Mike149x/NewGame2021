extends Spatial



var bullet_speed = 2
var direction


#This function makes the bullet go towards the player when spawned

func _ready():
	var player_pos = get_parent().get_node("Player").global_transform.origin
	player_pos.y += 1
	var bullet_pos = global_transform.origin
	direction = player_pos - bullet_pos
	direction = direction.normalized()

func _process(delta):
	translate(direction * bullet_speed * delta)



#The bullet can phase through other enemy types, only hitting the player
func _on_Area_body_entered(body):
	if body.filename != "res://Scenes/EnemyZombieShooter.tscn" and body.filename != "res://Scenes/EnemyZombie.tscn" and body.filename != "res://Scenes/EnemySpinningShooter.tscn":
		queue_free()
	
