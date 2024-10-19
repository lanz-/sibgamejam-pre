extends TextureRect


const REGIONS = {
	'0': Vector2(64, 448),
	'1': Vector2(64, 384),
	'2': Vector2(64, 320),
	'3': Vector2(128, 384),
	'4': Vector2(64, 192),
	'5': Vector2(128, 128),
	'6': Vector2(0, 576),
	'7': Vector2(0, 512),
	'8': Vector2(0, 448),
	'9': Vector2(64, 256),
	' ': Vector2(640, 384),
}


var digit: String = ' ':
	set(value):
		digit = value
		_refresh()


# Called wwen the node enters the scene tree for the first time.
func _ready() -> void:
	texture = texture.duplicate()
	_refresh()


func _refresh():
	texture.region = Rect2(REGIONS[digit], Vector2(64, 64))
