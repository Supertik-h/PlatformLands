extends Area2D

var entered = false
signal lever_activated  # Sygnał do aktywacji dźwigni
signal tiger_lever_activated

@export var next_scene: String = "res://scenes/jungle_biome.tscn"
var player

func _ready() -> void:
	player = get_node("Player")
	
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:  # Sprawdzamy, czy to gracz
		entered = true
		print("wazedl")
		change_scene()
		
		
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		entered = false

func change_scene():
	await get_tree().create_timer(0.1).timeout  # Krótkie opóźnienie (zapobiega wielokrotnemu wywołaniu)
	get_tree().change_scene_to_file(next_scene)
	if Global.tiger_byl_o:
		tiger_lever_activated.emit()
	if Global.panda_byla_o:
		lever_activated.emit()
	Global.changed = true
	
	
