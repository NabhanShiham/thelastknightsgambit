extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scene/level_1.tscn")
	
