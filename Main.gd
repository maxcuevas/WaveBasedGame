extends Node2D
var enemy = preload("res://enemy.tscn")

func _on_EnemyRespawnTimer_timeout():
	var newEnemy = enemy.instance()
	add_child(newEnemy)
	print($TextureProgress.value)
	$TextureProgress.value-=10

func _on_Player_death():
	get_tree().paused = true
	$GameOverLabel.show()