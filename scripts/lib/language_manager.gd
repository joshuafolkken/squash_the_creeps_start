class_name LanguageManager
extends Node

signal language_changed

const SETTINGS = {PATH = "user://settings.cfg", SECTION = "language", KEY = "locale"}
const DEFAULT_LOCALE = "en"

const SUPPORTED_LOCALES: Dictionary[String, String] = {
	"English": "en",
	"日本語": "ja",
}


func get_supported_languages() -> Array[String]:
	return SUPPORTED_LOCALES.keys()


func get_current_language_index(locale_code: String) -> int:
	for language_name in SUPPORTED_LOCALES:
		if SUPPORTED_LOCALES[language_name] == locale_code:
			return SUPPORTED_LOCALES.keys().find(language_name)
	return 0


func change_language(language_name: String) -> void:
	var locale_code := SUPPORTED_LOCALES[language_name]
	_save_locale(locale_code)
	TranslationServer.set_locale(locale_code)
	language_changed.emit()


func load_saved_language() -> String:
	var locale_code := _load_locale()
	TranslationServer.set_locale(locale_code)
	return locale_code


func _load_locale() -> String:
	var config := ConfigFile.new()
	if config.load(SETTINGS.PATH) != OK:
		_handle_config_error("load")
		return DEFAULT_LOCALE
	return config.get_value(SETTINGS.SECTION, SETTINGS.KEY, DEFAULT_LOCALE)


func _save_locale(locale_code: String) -> void:
	var config := ConfigFile.new()
	config.set_value(SETTINGS.SECTION, SETTINGS.KEY, locale_code)
	if config.save(SETTINGS.PATH) != OK:
		_handle_config_error("save")


func _handle_config_error(operation: String) -> void:
	push_warning("Failed to %s language settings." % operation)
