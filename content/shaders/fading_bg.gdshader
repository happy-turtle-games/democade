shader_type canvas_item;


uniform sampler2D texture_a;
uniform sampler2D texture_b;

uniform float fade : hint_range(0.0, 1.0);


void fragment() {
	COLOR = mix(texture(texture_a, UV), texture(texture_b, UV), fade);
}
