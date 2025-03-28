extends Control

@onready var start_button: TextureButton = $StartButton
@onready var exit_button: TextureButton = $ExitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	$AnimationPlayer.play("RESET")
	visible = false 
	#start_button.pressed.connect(start_game)
	#exit_button.pressed.connect(exit_game)
	
func _process(delta: float) -> void:
	testEsc()
		
func _on_start_button_pressed() -> void:
	print("nacisnieto")
	resume()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false  # Ukryj menu po wznowieniu
	
func pause():
	visible = true 
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	 # Pokaż menu po zatrzymaniu gry
	
func testEsc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()


func _on_start_button_mouse_entered() -> void:
	print("myskza")


func _on_texture_button_pressed() -> void:
	print("kolorki")


func _on_button_pressed() -> void:
	print("zwykly")
