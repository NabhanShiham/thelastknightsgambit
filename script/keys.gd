extends Area2D

@signal collected

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Ensure the player is in the correct group
		emit_signal("collected")   # Signal to notify collection
		queue_free()               
