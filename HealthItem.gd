extends Area2D
var health_restore_points = 25

func _ready():
	pass # Replace with function body.

func create(position):
	global_position = position

func _on_HealthItem_body_entered(body):
	if "Player" in body.name:
		body.health_points+= 25
		if body.health_points > 100:
			body.health_points = 100
		queue_free()
