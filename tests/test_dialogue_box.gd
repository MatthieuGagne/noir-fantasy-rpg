extends GutTest

var _box: Control


func before_each() -> void:
	_box = Control.new()
	_box.set_script(load("res://scripts/ui/dialogue_box.gd"))
	add_child(_box)


func after_each() -> void:
	if is_instance_valid(_box):
		_box.free()


func test_initially_hidden() -> void:
	assert_false(_box.visible)


func test_show_text_makes_visible_and_starts_typing() -> void:
	_box.show_text("Hello world")
	assert_true(_box.visible)
	assert_true(_box.is_typing)


func test_skip_during_typing_shows_full_text() -> void:
	_box.show_text("Hello world")
	_box.skip_or_dismiss()
	assert_false(_box.is_typing)
	assert_eq(_box.get_displayed_text(), "Hello world")


func test_dismiss_after_skip_hides_box() -> void:
	_box.show_text("Hello world")
	_box.skip_or_dismiss()  # skip to full text
	_box.skip_or_dismiss()  # dismiss
	assert_false(_box.visible)


func test_opened_signal_emitted_on_show_text() -> void:
	watch_signals(_box)
	_box.show_text("Test")
	assert_signal_emitted(_box, "opened")


func test_closed_signal_emitted_on_dismiss() -> void:
	watch_signals(_box)
	_box.show_text("Test")
	_box.skip_or_dismiss()  # skip
	_box.skip_or_dismiss()  # dismiss
	assert_signal_emitted(_box, "closed")


func test_advance_typewriter_adds_character() -> void:
	_box.show_text("AB")
	_box._on_timer_timeout()
	assert_eq(_box.get_displayed_text(), "A")
	_box._on_timer_timeout()
	assert_eq(_box.get_displayed_text(), "AB")


func test_typewriter_completes_on_last_char() -> void:
	_box.show_text("X")
	_box._on_timer_timeout()
	assert_false(_box.is_typing)
