extends Node2D

@onready var player: CharacterBody2D = $Player

@onready var hearts_container: HBoxContainer = $CanvasLayer2/heartsContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts_container.setMaxHearts(3)
	hearts_container.updateHearts(player.currentHealth)
	player.healthChanged.connect(hearts_container.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
