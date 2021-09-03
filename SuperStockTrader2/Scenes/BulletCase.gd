extends RigidBody






func _ready():
	add_to_group("ignore")

#func _physics_process(delta):
	#add_central_force(get_global_transform().basis.x * 500 * delta)
