extends Camera2D


# Margin around the viewport in pixels (can be adjusted)
@export var margin: int = 50

# Set limits automatically based on viewport size
func _ready() -> void:
	update_limits()
	# Automatically update limits if the window size changes
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_size_changed"))

# Update camera limits to match the viewport size
func update_limits() -> void:
	var viewport_size := get_viewport_rect().size
	var world_size :Vector2 = get_world_2d().get_bounds().size

	# Calculate limits considering the margin
	limit_left = -margin
	limit_top = -margin
	limit_right = world_size.x + margin - viewport_size.x
	limit_bottom = world_size.y + margin - viewport_size.y

	# Clamp to ensure limits do not go negative
	limit_right = max(limit_right, 0)
	limit_bottom = max(limit_bottom, 0)

# Called when viewport size changes
func _on_viewport_size_changed() -> void:
	update_limits()
