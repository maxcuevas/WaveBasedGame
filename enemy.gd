extends KinematicBody2D
var health_item = preload("res://HealthItem.tscn")
var ammo_item = preload("res://Ammunition.tscn")

var healthPoints = 100
var damage = 10
var hunting = false
var inMeleeRange = false
var playerBody = Vector2()
var speed = 100
var damage_taken_label_original_position
var timers_for_damage_taken_labels = []
var damage_taken_labels = []
var points_entity_is_worth = 10
var crazy = false

signal died(points_worth_kill)
signal create_health_drop(health_dropped)
signal create_ammo_drop(ammo_dropped)

func _ready():
	damage_taken_label_original_position = $DamageTakenLabel.rect_position

func create(current_level):
	healthPoints+=current_level*10
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var chance_to_be_crazy = rng.randi_range(0, 10)
	if chance_to_be_crazy <=1:
		crazy = true

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
		emit_signal("died",points_entity_is_worth)
		
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_number = rng.randi_range(0,100)
		
		if random_number <= 30 and random_number >= 0 :
			var health_drop = health_item.instance()
			health_drop.create(global_position)
			emit_signal("create_health_drop",health_drop)
		
		random_number = rng.randi_range(0,100)
		
		if random_number <= 30 and random_number >= 0 :
			var ammo_drop = ammo_item.instance()
			ammo_drop.create(global_position)
			emit_signal("create_ammo_drop",ammo_drop)
		
		queue_free()
		

func _physics_process(delta):
	$Sprite.modulate = Color(1, 1,1)
	
	for i in range(timers_for_damage_taken_labels.size() -1, -1 ,-1):
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
		
	if crazy:
		rotation+=0.3
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
