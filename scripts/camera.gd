extends Camera2D

@onready var panel = get_node("../Panel")

var mouse_position = Vector2()
var mouse_pos_global = Vector2()
var dragging_start = Vector2()
var dragging_end = Vector2()
var dragging_start_vec = Vector2()
var dragging_end_vec = Vector2()
var is_dragging = false

signal area_selected
signal start_move_selection

func _process(_delta):
	if(Input.is_action_just_pressed("left_click")):
		dragging_start = mouse_pos_global
		dragging_start_vec = mouse_position
		is_dragging = true
	if(is_dragging):
		dragging_end = mouse_pos_global
		dragging_end_vec = mouse_position
		draw_area()
	if(Input.is_action_just_released("left_click")):
		if(dragging_start_vec.distance_to(mouse_position) > 20):
			dragging_end = mouse_pos_global
			dragging_end_vec = mouse_position
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			dragging_end = dragging_start
			is_dragging = false
			draw_area(false)

func _input(event):
	if(event is InputEventMouse):
		mouse_position = event.position
		mouse_pos_global = get_global_mouse_position()

func draw_area(s=true):
	panel.visible = true
	panel.size = Vector2(abs(dragging_start_vec.x - dragging_end_vec.x), abs(dragging_start_vec.y-dragging_end_vec.y))
	var drawing_position = Vector2()
	drawing_position.x = min(dragging_start_vec.x, dragging_end_vec.x)
	drawing_position.y = min(dragging_start_vec.y, dragging_end_vec.y)
	panel.position = drawing_position
	panel.size *= int(s)
