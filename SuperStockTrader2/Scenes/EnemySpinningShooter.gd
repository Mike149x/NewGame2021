extends KinematicBody


var player
var follow_player = false
var move_speed = 20
var can_shoot = false
var health = 3
#establishing nodes we will be calling, as variables
onready var bullet = preload("res://Scenes/EnemyBullet.tscn")
var ammo_box = preload("res://Scenes/AmmoBox.tscn")
var medkit = preload("res://Scenes/Medkit.tscn")
onready var blood = preload("res://Scenes/BloodSpray.tscn")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
