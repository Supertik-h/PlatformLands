extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	visible = false  # Ukryj menu na start

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false  # Ukryj menu po wznowieniu
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	visible = true  # Pokaż menu po zatrzymaniu gry
	
func testEsc():
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()
	if get_tree().paused:
		print("Gra jest zapauzowana!")


func _on_button_pressed() -> void:
	print("dupa")
