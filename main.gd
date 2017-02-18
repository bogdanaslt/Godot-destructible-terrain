extends Control

const GRAVITY = Vector2(0, 98)

var background_data
var background_rect

var explosion = preload("res://explosion.png")
var explosion_data
var explosion_size

onready var sprite = get_node("hero")
var collision_pixel = Vector2(0, 32) # collision pixel offset in sprite

func _ready():
	randomize()
	sprite.set_pos(Vector2(rand_range(32, 1000), 100))
	
	background_data = get_node("background").get_texture().get_data()
	background_rect = background_data.get_used_rect()
	explosion_data = explosion.get_data()
	explosion_size = explosion.get_size()
	set_process(true)
	set_process_input(true)

func _process(delta):
	var pixel_pos = sprite.get_pos() + collision_pixel - get_node("background").get_pos()
	var c = Color(0, 0, 0, 0)
	if pixel_in_background(pixel_pos):
		c = background_data.get_pixel(pixel_pos.x, pixel_pos.y)
	if (c.a == 0):
		sprite.set_global_pos(sprite.get_global_pos() + GRAVITY * delta)

func pixel_in_background(pixel):
	return background_rect.has_point(pixel)

func _input(event):
	var data_modified = false
	if(event.type == InputEvent.MOUSE_BUTTON):
		var mouse_pos = get_global_mouse_pos() - get_node("background").get_pos() - (explosion_size / 2)
		for x in range(0, explosion_size.width):
			for y in range(0, explosion_size.height):
				if explosion_data.get_pixel(x, y).a > 0 and pixel_in_background(Vector2(mouse_pos.x + x, mouse_pos.y + y)):
					background_data.put_pixel(mouse_pos.x + x, mouse_pos.y + y, Color(0, 0, 0, 0))
					data_modified = true
	if data_modified:
		get_node("background").get_texture().set_data(background_data)