extends Node2D

@onready var player: CharacterBody2D = $Player


@onready var hearts_container: HBoxContainer = $CanvasLayer/heartsContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hearts_container == null:
		print("BŁĄD: Nie znaleziono heartsContainer!")
	hearts_container.setMaxHearts(player.maxHealth)
	hearts_container.updateHearts(player.currentHealth)
	player.healthChanged.connect(hearts_container.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
