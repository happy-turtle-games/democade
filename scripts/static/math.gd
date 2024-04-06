class_name Math extends RefCounted


static func smooth(factor: float, delta: float) -> float:
	return 1 - exp(-delta * factor)
