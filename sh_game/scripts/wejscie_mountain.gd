extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: CharacterBody2D) -> void:
	if body is CharacterBody2D:
		Global.last_entry_position = body.global_position - Vector2(10, 0)
		print(Global.last_entry_position)
		get_tree().change_scene_to_file("res://scenes/mountain.tscn")


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
