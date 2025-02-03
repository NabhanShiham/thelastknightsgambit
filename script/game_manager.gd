extends Node

# Tracks the current level
var current_level = 1
@export var max_level = 10  # Set maximum level, can be adjusted later

# This is to store the name or path of each level's scene
var level_scene_paths = [
	"res://scene/level_1.tscn",  # Add your level scenes here
	"res://scene/level_2.tscn",
	"res://scene/level_3.tscn",
	"res://scene/level_4.tscn",
	"res://scene/game_over.tscn",
]

# This will store the number of enemies required to be killed per level
var enemies_to_kill_per_level = [
	1,  # Enemies to kill for level 2
	2,  # Enemies to kill for level 3
	3,  # Enemies to kill for level 4
	4,  # Enemies for game over
]

@export var game_over_scene = "res://scene/game_over.tscn"
# Tracks the number of enemies killed
var enemies_killed = 0

# Called when the game starts or when a level is loaded
func _ready():
	print("Game Manager Ready")

# Function to change the level after the player defeats the required number of enemies
func change_level():
	# Check if the number of enemies killed is equal to the required kills for the current level
	if enemies_killed >= enemies_to_kill_per_level[current_level - 1]:
		if current_level < max_level:
			current_level += 1
			load_level(current_level)
			enemies_killed = 0  # Reset kill count for the new level
		else:
			print("Game Over! All levels completed.")
			# Trigger game over or win logic (e.g., show final screen, etc.)
	else:
		print("Not enough enemies defeated yet. Kill more enemies to advance!")

# Function to load the scene for a given level using PackedScene
func load_level(level_index: int):
	if level_index <= level_scene_paths.size():
		# Load the scene as a PackedScene object
		var next_scene = load(level_scene_paths[level_index - 1])  # -1 because array is 0-based
		if next_scene is PackedScene:
			# Change to the loaded PackedScene
			get_tree().change_scene_to_packed(next_scene)
		else:
			print("Error: Scene for level ", level_index, " is not a valid PackedScene.")
	else:
		print("No scene found for level ", level_index)

# This function should be called by the enemy whenever it dies
func enemy_killed():
	enemies_killed += 1
	print("Enemies killed: ", enemies_killed)
	change_level()  # Check if it's time to change level
	
