extends AnimatableBody2D

@onready var area = $Area2D
signal player_under_gate

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)  # Poprawiona nazwa funkcji
	area.body_exited.connect(_on_area_2d_body_exited)  # Poprawiona nazwa funkcji

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	print("wszedlwszy")
	if body is CharacterBody2D:  # Sprawdzamy, czy to gracz
		player_under_gate.emit(body)  # Wysyłamy sygnał z graczem

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body is CharacterBody2D:
		player_under_gate.emit(null)  # Gracz wyszedł, więc wysyłamy null
