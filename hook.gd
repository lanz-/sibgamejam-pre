extends CharacterBody2D

signal flown_too_far
signal stuck(collider_id)


const SPEED = 2000.0

enum {IN_HAND, IN_AIR, STUCK}

var direction = Vector2.RIGHT
var max_rope = 750.0
var current_rope = 0.0
var state = IN_HAND


func throw(to):
	Global.audio_manager.play_stream(Refs.S_THROW)
	current_rope = 0
	direction = (to - global_position).normalized()
	state = IN_AIR

func recall():
	state = IN_HAND


func _physics_process(delta: float) -> void:
	if state != IN_AIR:
		return
	
	var motion = SPEED * direction * delta
	
	var collision: KinematicCollision2D = move_and_collide(motion)
	if collision:
		Global.audio_manager.play_stream(Refs.S_IMPACT)
		state = STUCK
		stuck.emit()
		return
		
	current_rope += motion.length()
	if current_rope > max_rope:
		flown_too_far.emit()
