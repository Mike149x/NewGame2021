extends Node

var health
var health_max
var ammo
var ammo_max
var lives
var lives_max
var current_level = 1
#var gun_damage

#Player Stats on startup
func _ready():
	health = 85
	health_max = 100
	ammo = 150
	ammo_max = 300
	lives = 3
	lives_max = 5
	#gun_damage = 1

#func _process(delta):
	#if ammo <= 0:
		#var gun_damage = 0.5

#Those functions clamp the values, meaning they can't go under 0, or over the max value
func change_health(amount):
	health += amount
	health = clamp(health, 0, health_max)

func change_ammo(amount):
	ammo += amount
	ammo = clamp(ammo, 0, ammo_max)

func change_lives(amount):
	lives += amount
	lives = clamp(lives, 0, lives_max)

#Those get_ functions store the value and lets's us call on it from other scripts
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

#This is the code for level transition
func change_level():
	current_level += 1
	get_tree().change_scene("res://Scenes/TestLevel" + str(current_level) + ".tscn")
	SoundPlayer.play("res://Sounds/Laser_004.wav")











