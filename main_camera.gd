extends Node2D

@export var drag_speed: int = 10
@export var cam_offset: Vector2 = Vector2(0, -150)
@export var x_drag: int = 200
@export var y_pos_drag: int = 100
@export var y_neg_drag: int = 50

var g_target: Vector2 = Vector2.ZERO
var g_actual: Vector2 = Vector2.ZERO

var vport: Viewport = null
var vcenter: Vector2 = Vector2.ZERO


func movedown(amount: float):
	g_actual.y += amount
	g_target.y += amount
	
	vport.canvas_transform = vport.canvas_transform.translated(Vector2(0, -amount))



func _update_target():
	g_target = global_position + cam_offset


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vport = get_viewport()
	vport.canvas_transform = Transform2D.IDENTITY
	g_actual = Vector2(1152 / 2, 648 / 2)
	_update_target()
	_warp_to(g_target, 0)


func _warp_to(g_point, speed):
	var offset = g_point - g_actual
	offset.x = move_toward(offset.x, 0, x_drag)
	if offset.y > 0:
		offset.y = move_toward(offset.y, 0, y_neg_drag)
	else:
		offset.y = move_toward(offset.y, 0, y_pos_drag)
	if offset.is_zero_approx():
		return

	if speed != 0:
		var step = offset.normalized() * speed
		if step.length_squared() < offset.length_squared():
			offset = step

	g_actual += offset
	vport.canvas_transform = vport.canvas_transform.translated(-offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_target()
	_warp_to(g_target, drag_speed)
	
