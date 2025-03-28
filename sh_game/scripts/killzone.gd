extends Area2D


var player
var checkpoint_manager

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2


func _on_body_entered(body: Node2D) -> void:
	if get_tree().current_scene.name == "Secret_pokoj":
		Engine.time_scale = 0.5
		#body.get_node("CollisionShape2D").queue_free()
		timer_2.start()
	else:	
		print("You died!!!!!")
		Engine.time_scale = 0.5
		#body.get_node("CollisionShape2D").queue_free()
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	#get_tree().reload_current_scene()
	player.position = checkpoint_manager.last_location

func  _ready() -> void:
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	player = get_parent().get_node("Player")


func _on_timer_2_timeout() -> void:
	player.position = checkpoint_manager.last_location
	Engine.time_scale = 1
