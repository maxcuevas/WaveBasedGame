extends Area2D

var damage = 100
var playerReference

func setDirection(player, directionOfFiring):
	rotation = directionOfFiring
	playerReference = player

func _physics_process(delta):
	position = playerReference.global_position

func _on_Knife_body_entered(body):
	if "enemy" in body.name:
		body.hit(damage)

func _on_Timer_timeout():
	queue_free()
