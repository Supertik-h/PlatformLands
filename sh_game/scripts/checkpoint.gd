extends Area2D

@onready var point_light_2d: PointLight2D = $PointLight2D

var checkpoint_manager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	checkpoint_manager.last_location = $RespawnPoint.global_position
	point_light_2d.enabled = true
