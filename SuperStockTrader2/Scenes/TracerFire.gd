extends RigidBody

export var bullet_speed = 5000

func _ready():
	add_to_group("ignore")
	pass

func _physics_process(delta):
	add_central_force(get_global_transform().basis.z * -bullet_speed * delta)


func _on_TracerFire_body_shape_entered(body_id, body, body_shape, local_shape):
	print(body.name)
	if not body.name == "Player" and not body.is_in_group("ignore"):
		print("hello")
		queue_free() #delete the scene from tree
	pass
  

func _on_TracerFire_body_entered(body):
	print(body.name)
	if not body.name == "Player" and not body.is_in_group("ignore"):
		print("hello")
		queue_free()
	pass 
