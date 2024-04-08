class_name PathUtil extends RefCounted


static func relative_path(path: String, relative: String) -> String:
	if path.begins_with("./"):
		return relative.path_join(path.substr(1))
	return path
