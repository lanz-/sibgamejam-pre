class_name GameManager
extends Node


const MAIN_SCENE = preload("res://main.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func restart_game():
	get_tree().change_scene_to_packed(MAIN_SCENE)
