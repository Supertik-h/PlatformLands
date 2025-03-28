extends Area2D

var entered = false

@export var nexxt_scene: String = "res://scenes/fire_biome.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:  # Sprawdzamy, czy to gracz
		entered = true
		if not Global.zebrana_ogien:
			if Global.zebrana:
				change_scene()  # Wywołujemy funkcję zmiany sceny

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		entered = false

func change_scene():
	await get_tree().create_timer(0.1).timeout  # Krótkie opóźnienie (zapobiega wielokrotnemu wywołaniu)
	get_tree().change_scene_to_file(nexxt_scene)
