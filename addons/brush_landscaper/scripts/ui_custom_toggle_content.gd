@tool
extends PropertyUI
class_name CustomToggleContent
# Shows content nodes if you press a button. Hides them if you press it again
# Usefull to preview large content without polluting the UI


@export var property_name_pressed:String = ""
@onready var _content_clip:Control = $ContentClip
@onready var _toggle_button:Button = $Toggle/Button
@onready var _content:VBoxContainer = $ContentClip/Content


func _ready():
	_toggle_button.text = property_name
	_toggle_button.toggled.connect( _on_toggled )

func _on_toggled(button_pressed:bool):
	var final_value:Vector2
	if button_pressed:
		_toggle_button.text = property_name_pressed
		final_value.y = _content.size.y
	else:
		_toggle_button.text = property_name
		final_value = Vector2.ZERO
	
	create_tween().tween_property(
		_content_clip,
		"custom_minimum_size",
		final_value,
		0.4
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func set_value(value):
	for element in _content.get_children():
		element.queue_free()
	for element in value:
		_content.add_child(element)
func get_value():
	return _content.get_children()

