extends Node2D
var enemy = preload("res://enemy.tscn")

func _on_EnemyRespawnTimer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x_location = rng.randf_range(0.0, 1e3)
	var y_location = rng.randf_range(0.0, 640.0)
	
	var newEnemy : KinematicBody2D = enemy.instance()
	newEnemy.global_position = Vector2(x_location,y_location)
	add_child(newEnemy)
	

func _on_Player_death():
	get_tree().paused = true
	$Camera2D/GameOverLabel.show()

func _on_Player_current_health(current_health_percentage):
	$Camera2D/TextureProgress.value = current_health_percentage


func _on_Player_position_changed(position):
	$Camera2D.global_position = position
