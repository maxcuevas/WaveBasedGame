extends Node2D
var enemy = preload("res://enemy.tscn")

func _on_EnemyRespawnTimer_timeout():
	var newEnemy = enemy.instance()
	add_child(newEnemy)

func _on_Player_death():
	get_tree().paused = true
	$GameOverLabel.show()

func _on_Player_current_health(current_health_percentage):
	$TextureProgress.value = current_health_percentage
