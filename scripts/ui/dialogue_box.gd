class_name DialogueBox
extends Control

const CHAR_INTERVAL: float = 0.05

signal opened
signal closed

var is_typing: bool = false

var _full_text: String = ""
var _char_index: int = 0
var _timer: Timer


func _ready() -> void:
	visible = false
	_timer = Timer.new()
	_timer.wait_time = CHAR_INTERVAL
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)


func show_text(text: String) -> void:
	_full_text = text
	_char_index = 0
	is_typing = true
	visible = true
	_timer.start()
	opened.emit()


func skip_or_dismiss() -> void:
	if is_typing:
		_timer.stop()
		_char_index = _full_text.length()
		is_typing = false
	else:
		visible = false
		closed.emit()


func get_displayed_text() -> String:
	return _full_text.left(_char_index)


func _on_timer_timeout() -> void:
	if _char_index < _full_text.length():
		_char_index += 1
		if _char_index == _full_text.length():
			is_typing = false
			_timer.stop()
