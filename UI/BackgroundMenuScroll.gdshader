shader_type canvas_item;
render_mode unshaded;

uniform float speed_divider;

void fragment() { // Called for every pixel the material is visible on.
	vec2 uv = UV + vec2(sin(TIME / speed_divider), cos(TIME / speed_divider)) / speed_divider;
	COLOR = texture(TEXTURE, uv);
}
