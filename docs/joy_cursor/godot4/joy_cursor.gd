extends Node


@export_group("Cursor", "cursor_")
@export var cursor_sensitivity := 600.0
@export var cursor_autogenerate_actions := true
@export var cursor_autogenerate_deadzone := 0.5

@export_group("Click", "click_")
@export var click_autogenerate_actions := true
@export var click_autogenerate_deadzone := 0.5


@onready var cursor := get_window().size / 2.0


func _ready() -> void:
	process_priority = -1000
	process_physics_priority = -1000
	
	if cursor_autogenerate_actions:
		add_cursor_action(&"cursor_left", JOY_AXIS_LEFT_X, -1.0)
		add_cursor_action(&"cursor_right", JOY_AXIS_LEFT_X, +1.0)
		add_cursor_action(&"cursor_up", JOY_AXIS_LEFT_Y, -1.0)
		add_cursor_action(&"cursor_down", JOY_AXIS_LEFT_Y, +1.0)
	
	if click_autogenerate_actions:
		add_click_action(&"cursor_lmb", JOY_BUTTON_B, JOY_AXIS_TRIGGER_LEFT)
		add_click_action(&"cursor_rmb", JOY_BUTTON_A, JOY_AXIS_TRIGGER_RIGHT)


func add_cursor_action(name: StringName, axis: JoyAxis, value: float) -> void:
	InputMap.add_action(name)
	InputMap.action_set_deadzone(name, cursor_autogenerate_deadzone)
	var event := InputEventJoypadMotion.new()
	event.device = -1
	event.axis = JOY_AXIS_LEFT_X
	event.axis_value = value
	InputMap.action_add_event(name, event)


func add_click_action(name: StringName, btn: JoyButton, axis: JoyAxis) -> void:
		InputMap.add_action(name)
		InputMap.action_set_deadzone(name, click_autogenerate_deadzone)
		
		var joy_btn := InputEventJoypadButton.new()
		joy_btn.device = -1
		joy_btn.button_index = btn
		InputMap.action_add_event(name, joy_btn)
		
		var joy_axis := InputEventJoypadMotion.new()
		joy_axis.device = -1
		joy_axis.axis = axis
		joy_axis.axis_value = 1.0
		InputMap.action_add_event(name, joy_axis)


func _process(delta: float) -> void:
	var diff := Input.get_vector(&'cursor_left', &'cursor_right', &'cursor_up', &'cursor_down')
	if not diff.is_zero_approx():
		cursor += diff * cursor_sensitivity * delta
		cursor = cursor.clamp(Vector2.ZERO, get_window().size)
		Input.warp_mouse(cursor)
		
		var event := InputEventMouseMotion.new()
		event.device = -1
		event.position = cursor
		event.relative = diff
		event.velocity = diff * delta
		Input.warp_mouse(cursor)
		Input.parse_input_event(event)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"cursor_lmb"):
		send_mouse_button(MOUSE_BUTTON_LEFT, true)
		return
	
	if event.is_action_released(&"cursor_lmb"):
		send_mouse_button(MOUSE_BUTTON_LEFT, false)
		return
	
	if event.is_action_pressed(&"cursor_rmb"):
		send_mouse_button(MOUSE_BUTTON_RIGHT, true)
		return
	
	if event.is_action_released(&"cursor_rmb"):
		send_mouse_button(MOUSE_BUTTON_RIGHT, false)
		return
	
	if event is InputEventMouseMotion:
		cursor = event.position


func send_mouse_button(mouse_btn: MouseButton, pressed: bool) -> void:
	var event = InputEventMouseButton.new()
	event.position = cursor
	event.device = -1
	event.pressed = false
	event.button_index = mouse_btn
	event.button_mask = pow(2, mouse_btn)
	Input.parse_input_event(event)
