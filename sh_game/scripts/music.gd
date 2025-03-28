extends Node


@onready var music: AudioStreamPlayer2D = $"."

func _ready():
	$".".stream.loop = true
	if music.playing:
		return  # Jeśli już gra, nie uruchamiaj ponownie
	music.play()
