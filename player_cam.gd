extends Camera2D


# Margin around the viewport in pixels (can be adjusted)
@export var margin: int = 50

# Set limits automatically based on viewport size
func _ready() -> void:
	pass


# Called when viewport size changes
func _on_viewport_size_changed() -> void:
	pass
