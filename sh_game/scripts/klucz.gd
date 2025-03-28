extends Area2D



func _on_body_entered(body: Node2D) -> void:
	print("klucz", Global.klucze)
	queue_free()
	Global.klucze += 1
	print(Global.klucze)
	Global.zebrano_klucz = true
