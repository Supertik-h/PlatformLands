extends Node2D

@onready var heartsContainer: HBoxContainer = $CanvasLayer2/heartsContainer
@onready var player: CharacterBody2D = $Player




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.setMaxHearts(player.maxHealth	)
	print_debug(player.currentHealth)
	heartsContainer.updateHearts(player.currentHealth)
	
	player.healthChanged.connect(heartsContainer.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
