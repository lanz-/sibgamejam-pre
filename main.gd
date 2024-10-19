extends Node2D

const SCREEN_SPACE = 670

@onready var screens = [$Screen0, $Screen1, $Screen2, $Screen3]
@onready var movables = [$Player]
@onready var hook = $Player/Hook
@onready var player = $Player
@onready var pleaving = $PlayerLeaving
@onready var pdying = $PlayerDying
@onready var camera = $Player/MainCamera
@onready var counter = $UI/Counter

var current_spawn_ratio = 96
var score = 0
var last_point = 0
var move_down = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager.set_ambient(Refs.S_WIND)
	Global.audio_manager.set_music(Refs.M_GUITAR)
	
	screens[0].respawn(101)
	screens[1].respawn(99)
	screens[2].respawn(98)
	screens[3].respawn(97)
	
	pleaving.body_entered.connect(_refresh_screens)
	pdying.body_entered.connect(_dying)
	
	counter.number = 0
	score = 0
	last_point = player.position.y


func _refresh_screens(body: Node2D) -> void:
	if body.is_in_group("player"):
		move_down = true
		screens[0].respawn.bind(current_spawn_ratio).call_deferred()
		current_spawn_ratio -= 1


func _dying(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(0.3).timeout
		Global.game_manager.restart_game()


func _physics_process(delta: float) -> void:
	var new_point = player.position.y
	if new_point < last_point:
		score += last_point - new_point
		counter.number = int(score)
		last_point = new_point
	
	if not move_down:
		return
	
	last_point += SCREEN_SPACE
	
	var refresh_screen = screens.pop_front()
	for movable in movables:
		movable.position.y += SCREEN_SPACE
	
	if not player.has_hook:
		hook.position.y += SCREEN_SPACE
		
	for screen in screens:
		screen.position.y += SCREEN_SPACE
	
	pdying.position.y = move_toward(pdying.position.y, 1600, SCREEN_SPACE)
		
	camera.movedown(SCREEN_SPACE)
	
	refresh_screen.position.y -= 3 * SCREEN_SPACE
	screens.append(refresh_screen)
	
	move_down = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
