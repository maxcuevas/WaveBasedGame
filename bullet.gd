extends KinematicBody2D

export (int) var speed = 750

var damage = 10
var velocity = Vector2()

func setDirectionOfFireAndLocation(velocityStart, directionOfFiring):
	rotation = directionOfFiring
	position = velocityStart
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("hit"):
	        collision.collider.hit(damage)
		queue_free()

func _on_timeUntilDespawn_timeout():
	queue_free()

