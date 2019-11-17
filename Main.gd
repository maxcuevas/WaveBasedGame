extends Node2D
var enemy = preload("res://enemy.tscn")
var current_level = 1
var number_of_enemies_left = 6

func _process(delta):
	$Camera2D/LevelNumberLabel.text = str(current_level)
	$Camera2D/EnemyCountNumberLabel.text = str(number_of_enemies_left)
	if number_of_enemies_left <= 0:
		$EnemyRespawnTimer.stop()
		new_level()
		$EnemyRespawnTimer.start()

func new_level():
	current_level+=1
	number_of_enemies_left = current_level * 5


func _on_EnemyRespawnTimer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x_location = rng.randf_range(0.0, 1e3)
	var y_location = rng.randf_range(0.0, 640.0)
	
	var newEnemy : KinematicBody2D = enemy.instance()
	newEnemy.create(current_level)
	newEnemy.connect("died",self, "_on_enemy_died")
	newEnemy.connect("create_health_drop", self, "_on_enemy_health_drop")
	newEnemy.connect("create_ammo_drop", self, "_on_enemy_ammo_drop")
	newEnemy.global_position = Vector2(x_location,y_location)
	add_child(newEnemy)
	

func _on_enemy_died(points_worth_kill):
	var current_points = int($Camera2D/pointCountNumberLabel.text)
	$Camera2D/pointCountNumberLabel.text = str(points_worth_kill + current_points)
	number_of_enemies_left-=1

func _on_enemy_health_drop(health_dropped):
	add_child(health_dropped)
	
func _on_enemy_ammo_drop(ammo_dropped):
	add_child(ammo_dropped)

func _on_Player_death():
	get_tree().paused = true
	$Camera2D/GameOverLabel.show()

func _on_Player_current_health(current_health_percentage):
	$Camera2D/TextureProgress.value = current_health_percentage


func _on_Player_position_changed(position):
	$Camera2D.global_position = position


func _on_Player_current_ammunition(ammunition):
	$Camera2D/AmmunitionCountLabel.text = str(ammunition)
