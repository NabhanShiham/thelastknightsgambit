extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/GameOverButton.grab_focus()

func _onGameOver_pressed():
	get_tree().change_scene_to_file("res://scene/OpeningScene.tscn")
