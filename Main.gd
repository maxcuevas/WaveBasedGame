extends Node2D
var enemy = preload("res://enemy.tscn")

func _ready():
	pass # Replace with function body.
	



func _on_EnemyRespawnTimer_timeout():
	var newEnemy = enemy.instance()
	add_child(newEnemy)
