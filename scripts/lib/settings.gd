class_name Settings


static func clear() -> void:
	var dir := DirAccess.open("user://")
	if dir and dir.file_exists("settings.cfg"):
		dir.remove("settings.cfg")
		push_warning("Language settings have been cleared.")
