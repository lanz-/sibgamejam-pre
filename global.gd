extends Node


var audio_manager = AudioManager.new()
var random_manager = RandomManager.new()
var game_manager = GameManager.new()

func _ready() -> void:
	add_child(audio_manager)
	add_child(random_manager)
	add_child(game_manager)
