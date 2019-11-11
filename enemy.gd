extends KinematicBody2D

var healthPoints = 500
var damage = 10
var hunting = false
var inMeleeRange = false
var playerBody = Vector2()
var speed = 100

func hit(damage):
	$Sprite.modulate = Color(1, 0, 0)	
	$AudioStreamPlayer2D.play()
	healthPoints-=damage
	if healthPoints <= 0:
		queue_free()

func _physics_process(delta):
	$Sprite.modulate = Color(1, 1,1)
	if hunting:
		var distanceFromPlayer = (playerBody.global_position - global_position).normalized()
		move_and_slide(distanceFromPlayer * speed)
	if inMeleeRange and $MeleeCooldown.time_left <= 0:
		playerBody.takeDamage(damage)
		$MeleeCooldown.start()
		

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		hunting = true
		playerBody = body

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		hunting = false

func _on_MeleeRange_body_entered(body):
	if body.name == "Player":
		inMeleeRange = true

func _on_MeleeRange_body_exited(body):
	if body.name == "Player":
		inMeleeRange = false
