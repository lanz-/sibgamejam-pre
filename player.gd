extends CharacterBody2D


const SPEED = 100
const MAX_X_SPEED = 300
const MAX_Y_SPEED = 600
const GROUND_FRICTION = 600
const AIR_FRICTION = 50

const JUMP_VELOCITY = -600.0
const HOOK_FORCE = 150
const MIN_HOOK_LEN = 10


@onready var hook = $Hook
@onready var hand = $HandMarker
@onready var rope = $Rope

var has_hook = true
var can_hook = true
var jump_buffer = false


func _ready() -> void:
	rope.clear_points()
	rope.add_point(Vector2.ZERO)
	rope.add_point(Vector2.ZERO)
	rope.hide()
	
	hook.flown_too_far.connect(_recall_hook)
	hook.stuck.connect(_on_hook_stuck)


func _throw_hook(to: Vector2):
	if not can_hook:
		return

	has_hook = false
	hook.reparent(get_parent())
	hook.throw(to)


func _recall_hook():
	hook.global_position = hand.global_position
	hook.reparent(self)
	hook.recall()
	has_hook = true
	can_hook = false
	get_tree().create_timer(0.5).timeout.connect(func(): can_hook = true)

func _on_hook_stuck():
	pass


func _process(delta: float) -> void:
	if has_hook:
		rope.hide()
		return
	
	rope.set_point_position(0, hand.position)
	rope.set_point_position(1, to_local(hook.global_position))
		
	rope.show()


func _physics_process(delta: float) -> void:
	var vel = velocity
	
	var direction := Input.get_axis("g_left", "g_right")
	# add horizontal up to max
	if direction:
		vel.x += direction * SPEED
	
	# in air gravity down
	if not is_on_floor():
		vel += get_gravity() * delta
		if not jump_buffer and Input.is_action_pressed("g_jump"):
			jump_buffer = true
			get_tree().create_timer(0.1).timeout.connect(func(): jump_buffer = false)
	else:
		if Input.is_action_just_pressed("g_jump") or jump_buffer:
			Global.audio_manager.play_stream(Refs.S_JUMP)
			vel.y = JUMP_VELOCITY
		
		if not direction:
			vel.x = move_toward(vel.x, 0, SPEED)
	
	if hook.state == hook.STUCK:
		var rvec = (hook.global_position - hand.global_position)
		if abs(rvec.length()) > MIN_HOOK_LEN:
			vel += rvec.normalized() * HOOK_FORCE
		else:
			_recall_hook()
			
	
	var impact = is_on_ceiling() or is_on_floor() or is_on_wall()
	if impact and abs(vel.length()) > 0:
		Global.audio_manager.start_impact()
	else:
		Global.audio_manager.stop_impact()

	
	vel.x = clampf(vel.x, -MAX_X_SPEED, MAX_X_SPEED)
	vel.y = clampf(vel.y, -MAX_Y_SPEED, MAX_Y_SPEED)
	velocity = vel
	
	var mouse_press = Input.is_action_pressed("g_hook")
		
	if has_hook:
		var mouse_pos = get_global_mouse_position()
	
		hook.look_at(mouse_pos)

		if mouse_press:
			_throw_hook(mouse_pos)
	else:
		if not mouse_press:
			_recall_hook()

	move_and_slide()
