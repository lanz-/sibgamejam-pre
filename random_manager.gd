class_name RandomManager
extends Node


var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func percent_chance(p):
	var v = rng.randi_range(0, 100)
	return v < p
	

func choice(arr):
	var i = rng.randi_range(0, len(arr) - 1)
	return arr[i]
