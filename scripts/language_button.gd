class_name LanguageButton
extends OptionButton

signal language_changed

var language_manager: LanguageManager


func _ready() -> void:
	language_manager = LanguageManager.new()
	add_child(language_manager)

	_configure_font_sizes()
	_initialize_language_options()
	_load_and_set_language()

	item_selected.connect(_on_item_selected)
	language_manager.language_changed.connect(func() -> void: language_changed.emit())


func _configure_font_sizes() -> void:
	add_theme_font_size_override("font_size", 18)
	get_popup().add_theme_font_size_override("font_size", 18)


func _initialize_language_options() -> void:
	for language_name in language_manager.get_supported_languages():
		add_item(language_name)
	selected = 0


func _load_and_set_language() -> void:
	var selected_locale := language_manager.load_saved_language()
	selected = language_manager.get_current_language_index(selected_locale)


func _on_item_selected(index: int) -> void:
	var selected_language := get_item_text(index)
	language_manager.change_language(selected_language)
