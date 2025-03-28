extends Area2D

@export var climb_speed: float = 100.0  # Prędkość wspinania się po drabinie

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

# Funkcja obsługująca wejście gracza na drabinę
func _on_body_entered(body):
	if body is CharacterBody2D:
		body.is_on_ladder = true
		body.velocity.y = 0  # Zatrzymaj pionowy ruch gracza, gdy wchodzi na drabinę

# Funkcja obsługująca wyjście gracza z drabiny
func _on_body_exited(body):
	if body is CharacterBody2D:
		body.is_on_ladder = false
