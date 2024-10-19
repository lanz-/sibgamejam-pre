extends Control

@onready var container = $HBoxContainer

var digit_scene = preload("res://digit.tscn")
var number = '':
	set(value):
		number = str(value)
		_update_counter()


var digits = []

func _update_counter():
	var dlen = len(digits)
	var nlen = len(number)
	
	if dlen > nlen:
		for i in range(nlen, dlen):
			digits[i].queue_free()
		digits.resize(nlen)
	else:
		digits.resize(nlen)
		for i in range(dlen, nlen):
			digits[i] = digit_scene.instantiate()
			container.add_child(digits[i])
	
	for i in digits.size():
		digits[i].digit = number[i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
