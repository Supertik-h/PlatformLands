extends Area2D

signal lever_activated  # Sygnał do aktywacji dźwigni
signal tiger_lever_activated

var is_used = false  # Czy dźwignia została użyta?

func _ready() -> void:
	var sprite = $AnimatedSprite2D  # Pobieramy referencję do animacji dźwigni


			
func _on_body_entered(body):
	if body.name == "Player" and not is_used:
		 
		if Global.klucze >= 2:
			is_used = true
			$AnimatedSprite2D.play("right")
			tiger_lever_activated.emit()
			Global.tiger_byl_o = true
			
			# Wysyłamy sygnał do Pandzi
		
		print("emituje")
