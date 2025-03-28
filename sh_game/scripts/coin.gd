extends Area2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var manager: Node = $"../../Manager"

func _on_body_entered(body: Node2D) -> void:
	manager.add_point()
	animation_player.play("pickup")
