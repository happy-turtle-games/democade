shader_type canvas_item;


uniform sampler2D texture_a;
uniform sampler2D texture_b;

uniform float fade : hint_range(0.0, 1.0);


vec2 aspect_cover(in vec2 size) {
	return min(size.x, size.y) / size;
}


vec4 aspect_tex(in sampler2D tex, in vec2 uv, in vec2 view_size) {
	vec2 size = vec2(textureSize(tex, 0));
	uv -= 0.5;
	uv *= aspect_cover(size / view_size);
	uv += 0.5;
	return texture(tex, uv);
}


void fragment() {
	vec4 tex_a = aspect_tex(texture_a, SCREEN_UV, 1.0 / SCREEN_PIXEL_SIZE);
	vec4 tex_b = aspect_tex(texture_b, SCREEN_UV, 1.0 / SCREEN_PIXEL_SIZE);
	COLOR = mix(tex_a, tex_b, fade);
}
