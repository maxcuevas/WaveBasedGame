extends KinematicBody2D
var bullet = preload("res://bullet.tscn")
var knife = preload("res://Knife.tscn")

signal death
signal current_health
signal position_changed(position)
signal current_ammunition(ammunition)

var speed = 200

var velocity = Vector2()
var health_points = 100
var max_health_points = 100
var ammunition = 50


func _ready():
	connect("body_entered", self, "_on_health_item_detected")


func _on_health_item_detected(who):
	if "HealthItem" in who.name:
		print("on health item")


func fire_bullet():
	if $RateOfFire.time_left <= 0 && ammunition > 0:
		ammunition-=1
		var b = bullet.instance()
		b.setDirectionOfFireAndLocation($gun.global_position, rotation)
		get_parent().add_child(b)
		$RateOfFire.start()

func melee():
	if $MeleeCooldown.time_left <= 0:
		var newKnife = knife.instance()
		newKnife.setDirection($gun, rotation)
		get_parent().add_child(newKnife)
		$MeleeCooldown.start()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	if Input.is_action_pressed('mouse_right_down'):
		fire_bullet()
	if Input.is_action_pressed('knife'):
		melee()
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	$Sprite.modulate = Color(1, 1, 1)	
	get_input()
	var dir = get_global_mouse_position() - global_position
	if dir.length() > 5:
	    rotation = dir.angle()
	    velocity = move_and_slide(velocity)
	emit_signal("position_changed",global_position)
	var health_percent : float = (float(health_points)/ float(max_health_points)) * 100.0
	emit_signal("current_health",health_percent)
	emit_signal("current_ammunition",ammunition)
	if health_points <= 0:
		emit_signal("death")
		queue_free()

func takeDamage(damageTaken):
	$Sprite.modulate = Color(1, 0, 0)	
	$AudioStreamPlayer2D.play()
	health_points-=damageTaken