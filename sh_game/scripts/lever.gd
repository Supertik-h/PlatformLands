extends Area2D

signal lever_activated  # Sygnał do aktywacji dźwigni
signal tiger_lever_activated

var is_used = false  # Czy dźwignia została użyta?

func _ready() -> void:
	var sprite = $AnimatedSprite2D  # Pobieramy referencję do animacji dźwigni


			
func _on_body_entered(body):
	if body.name == "Player" and not is_used:
		is_used = true
		$AnimatedSprite2D.play("right")
		#await $AnimatedSprite2D.animation_finished  # Czekamy, aż skończy animację
		#await get_tree().create_timer(2.0).timeout  # Czekamy 2 sekundy
		lever_activated.emit()  # Wysyłamy sygnał do Pandzi
		Global.panda_byla_o = true
		print("emituje")
