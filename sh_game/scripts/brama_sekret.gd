extends AnimatableBody2D

@onready var area = $Area2D
signal player_under_gate


func _on_blackbutton_body_entered(body: Node2D) -> void:
	print("wszedlwszy")
	if body is CharacterBody2D:  # Sprawdzamy, czy to gracz
		player_under_gate.emit(body)  # Wysyłamy sygnał z graczem


func _on_blackbutton_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_under_gate.emit(null) 
