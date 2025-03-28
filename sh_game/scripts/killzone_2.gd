extends Area2D

@onready var timer_2: Timer = $Timer2




func _on_body_entered(body: CharacterBody2D) -> void:
	print("You died!!!!!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer_2.start()


func _on_timer_2_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
