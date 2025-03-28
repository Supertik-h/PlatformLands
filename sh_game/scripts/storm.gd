extends Area2D



@onready var gol: AnimationPlayer = $AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: CharacterBody2D) -> void:
	#print("klucz", Global.klucze)
	animation_player.play("pickup")
	Global.dash += 1
	print("Dodane")
	Global.zebrano = true
	#await get_tree().create_timer(0.2).timeout
	
	queue_free()
	
	
	#print(Global.klucze)
