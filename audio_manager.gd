class_name AudioManager
extends Node

const NUM_PLAYERS = 8

var ambient_player = null
var impact_player = null
var music_player = null
var can_play_impact = true

var available = []
var queue = []


func _ready() -> void:
	for i in NUM_PLAYERS:
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.finished.connect(_on_stream_finished.bind(player))
		available.append(player)
	
	ambient_player = AudioStreamPlayer.new()
	add_child(ambient_player)
	impact_player = AudioStreamPlayer.new()
	impact_player.stream = Refs.S_COLLISION
	add_child(impact_player)
	music_player = AudioStreamPlayer.new()
	add_child(music_player)


func _process(delta: float) -> void:
	if available and queue:
		var player = available.pop_front()
		player.stream = queue.pop_front()
		player.play()
	

func _on_stream_finished(player):
	available.append(player)


func play_stream(stream):
	queue.append(stream)


func set_ambient(stream):
	if ambient_player.playing:
		ambient_player.stop()

	ambient_player.stream = stream
	ambient_player.play()


func set_music(stream):
	if music_player.playing:
		music_player.stop()
	
	music_player.stream = stream
	music_player.play()


func start_impact():
	if not can_play_impact:
		return
	
	if impact_player.playing:
		return
	
	impact_player.play()
	can_play_impact = false


func stop_impact():
	if impact_player.playing:
		impact_player.stop()
	can_play_impact = true
