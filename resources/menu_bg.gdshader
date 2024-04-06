shader_type canvas_item;


uniform float blur_amount = 4.0;
uniform float gray_amount: hint_range(0.0, 1.0) = .5;


uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec3 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb;
	float gray = screen.r * 0.3 + screen.g * 0.59 + screen.b * 0.11;
	
	COLOR.rgb = mix(COLOR.rgb, mix(screen, vec3(gray), gray_amount), COLOR.a);
	COLOR.a = 1.0;
}
