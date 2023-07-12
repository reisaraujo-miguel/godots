static func clear_and_free(dict: Dictionary) -> void:
	var old_values = dict.values()
	dict.clear()
	for x in old_values:
		x.free()
