extends KinematicBody2D

var healthPoints = 500
var damage = 10
var hunting = false
var inMeleeRange = false
var playerBody = Vector2()
var speed = 100
var damage_taken_label_original_position
var timers_for_damage_taken_labels = []
var damage_taken_labels = []


func _ready():
	damage_taken_label_original_position = $DamageTakenLabel.rect_position

func hit(damage):
	$Sprite.modulate = Color(1, 0, 0)	
	$AudioStreamPlayer2D.play()
	
	timers_for_damage_taken_labels.append(Timer.new())
	add_child(timers_for_damage_taken_labels.back())
	timers_for_damage_taken_labels.back().wait_time = 0.5
	timers_for_damage_taken_labels.back().one_shot = true
	timers_for_damage_taken_labels.back().start()
	
	damage_taken_labels.append(Label.new())
	add_child(damage_taken_labels.back())
	damage_taken_labels.back().rect_position = damage_taken_label_original_position
	damage_taken_labels.back().text = str(damage)
	
	healthPoints-=damage
	if healthPoints <= 0:
		queue_free()
		

func _physics_process(delta):
	$Sprite.modulate = Color(1, 1,1)
	
	
	for i in range(timers_for_damage_taken_labels.size() -1, -1 ,-1):
		print_debug(timers_for_damage_taken_labels[i].time_left)
		if timers_for_damage_taken_labels[i].time_left <= 0:
			damage_taken_labels[i].queue_free()
			damage_taken_labels.remove(i)
			timers_for_damage_taken_labels[i].queue_free()
			timers_for_damage_taken_labels.remove(i)
	
	for i in damage_taken_labels:
		i.rect_global_position+= Vector2(0,-0.5)
	
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
