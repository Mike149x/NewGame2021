extends Spatial

#func _ready():
	#UserInterface.hide()
	

func _on_NewGame_pressed():
	get_tree().change_scene("res://Scenes/TestLevel1.tscn")
	UserInterface.show()


func _on_Quit_pressed():
	get_tree().quit()
