extends Spatial


var bullet_speed = 1.5
var direction

func _ready():
	pass
	
	var bullet_pos = global_transform.origin
	direction = bullet_pos
	direction = direction.normalized()



func _process(delta):
	translate(direction * bullet_speed * delta)






func _on_SpinningArea_body_entered(body):
	if body.filename != "res://Scenes/EnemyZombieShooter.tscn" and body.filename != "res://Scenes/EnemySpinningShooter.tscn":
		queue_free()
