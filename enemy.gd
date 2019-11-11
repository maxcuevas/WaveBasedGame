extends KinematicBody2D

var healthPoints = 750
var hunting = false
var playerBody = Vector2()
var speed = 100

func hit(damage):
	$Sprite.modulate = Color(1, 0, 0)	
	healthPoints-=damage
	if healthPoints <= 0:
		queue_free()

func _physics_process(delta):
	$Sprite.modulate = Color(1, 1,1)
	if hunting:
		var distanceFromPlayer = (playerBody.global_position - global_position).normalized()
		move_and_slide(distanceFromPlayer * speed)
		
#		if distanceFromPlayer < 10:
#			pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		hunting = true
		playerBody = body

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		hunting = false
