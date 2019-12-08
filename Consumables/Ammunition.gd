extends Area2D

var ammunition_restore = 25

func _ready():
	pass # Replace with function body.

func create(position):
	global_position = position

func _on_Ammunition_body_entered(body):
	if "Player" in body.name:
		body.ammunition+= 25
		queue_free()