extends Control


#These are the values tracked in the game UI
#This code makes sure they update accordingly, and that the progress bars work
func _ready():
	$HealthBar.max_value = PlayerStats.health_max
	$AmmoBar.max_value = PlayerStats.ammo_max
	

func _process(delta):
	$HealthBar.value = PlayerStats.get_health()
	$AmmoCount.text = "x " + PlayerStats.get_ammo()
	$LifeCounter.text = PlayerStats.get_lives()
	$AmmoBar.value = int(PlayerStats.get_ammo())
	


