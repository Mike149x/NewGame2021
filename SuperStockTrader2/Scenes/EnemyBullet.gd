extends Spatial



var bullet_speed = 2
var direction


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_pos = get_parent().get_node("Player").global_transform.origin
	player_pos.y += 1
	var bullet_pos = global_transform.origin
	direction = player_pos - bullet_pos
	direction = direction.normalized()

func _process(delta):
	translate(direction * bullet_speed * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.filename != "res://Scenes/EnemyZombieShooter.tscn" and body.filename != "res://Scenes/EnemySpinningShooter.tscn":
		queue_free()
	
