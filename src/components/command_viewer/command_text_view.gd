class_name CommandTextView
extends VBoxContainer

@onready var _copy_to_clipboard: Button = %CopyToClipboard
@onready var _rich_text_label: RichTextLabel = %RichTextLabel
@onready var _title: Label = %Title
@onready var _icon_rect := %IconRect as TextureRect

var _text := ""


var remove_btn: Button:
	get: return %Delete


var copy_btn: Button:
	get: return %Copy


var create_process_btn: Button:
	get: return %CreateProcess


var execute_btn: Button:
	get: return %Execute


var edit_btn: Button:
	get: return %Edit


func _ready() -> void:
	_rich_text_label.custom_minimum_size = Vector2i(0, 100) * Config.EDSCALE
	_copy_to_clipboard.pressed.connect(func() -> void:
		if _text and not _text.is_empty():
			DisplayServer.clipboard_set(_text)
	)


func set_text(title: String, tooltip: String, text: String, icon: String) -> void:
	_title.tooltip_text = tooltip
	_title.text = title
	_text = text
	_rich_text_label.tooltip_text = tooltip
	_rich_text_label.clear()
	_rich_text_label.push_color(get_theme_color("string_color", "CodeEdit"))
	_rich_text_label.append_text(text)
	_icon_rect.texture = get_theme_icon(icon, "EditorIcons")
