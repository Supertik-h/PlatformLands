extends PathFollow2D

@export var speed: float = 50.0  # Szybkość lotu papugi

func _ready():
	$AnimatedSprite2D.play("fly")  # Zastąp "fly" nazwą twojej animacji

func _process(delta):
	progress += speed * delta  # Ruch wzdłuż ścieżki
