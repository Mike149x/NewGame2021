extends Node

var health
var health_max
var ammo
var ammo_max
var lives
var lives_max
var current_level = 1
#var gun_damage


func _ready():
	health = 85
	health_max = 100
	ammo = 50
	ammo_max = 100
	lives = 3
	lives_max = 5
	#gun_damage = 1

#func _process(delta):
	#if ammo <= 0:
		#var gun_damage = 0.5

func change_health(amount):
	health += amount
	health = clamp(health, 0, health_max)

func change_ammo(amount):
	ammo += amount
	ammo = clamp(ammo, 0, ammo_max)

func change_lives(amount):
	lives += amount
	lives = clamp(lives, 0, lives_max)

func get_health():
	return health

func get_ammo():
	return str(ammo)

func get_lives():
	return str(lives)

#func get_gun_damage():
	#return(gun_damage)

func has_ammo():
	return ammo > 0

func reset():
	health = health_max
	ammo = ammo_max

func change_level():
	current_level += 1
	get_tree().change_scene("res://Scenes/TestLevel" + str(current_level) + ".tscn")











