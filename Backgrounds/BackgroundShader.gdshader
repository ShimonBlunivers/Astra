shader_type canvas_item;
render_mode unshaded;

uniform vec2 background_position;
uniform float speed_divider;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV + background_position / speed_divider;
	COLOR = texture(TEXTURE, uv);
}
