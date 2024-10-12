shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform int pixel_size = 4;

void vertex() {
	float nw = (1.0*float(pixel_size));
	if (NORMAL.x == 1.0 || NORMAL.y == 1.0 || NORMAL.z == 1.0 || NORMAL.x == -1.0 || NORMAL.y == -1.0 || NORMAL.z == -1.0){
		VERTEX *= 1.0+0.01*nw;
	}
	if ((NORMAL.x != 1.0 && NORMAL.y != 0.0 && NORMAL.z != 0.0) && (NORMAL.y != 1.0 && NORMAL.x != 0.0 && NORMAL.z != 0.0) && (NORMAL.z != 1.0 && NORMAL.x != 0.0 && NORMAL.y != 0.0) && (NORMAL.x != -1.0 && NORMAL.y != 0.0 && NORMAL.z != 0.0) && (NORMAL.y != -1.0 && NORMAL.x != 0.0 && NORMAL.z != 0.0) && (NORMAL.z != -1.0 && NORMAL.x != 0.0 && NORMAL.y != 0.0)){
		VERTEX += NORMAL*0.01*nw;
	}
}

void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);
	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;
	vec4 oldtext = texture(SCREEN_TEXTURE,SCREEN_UV*1.0);
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, vec2(x, y) / (VIEWPORT_SIZE));
	if (pixelatedtext.a==0.0 && oldtext.a==0.0){
		discard;
	}
	ALBEDO = pixelatedtext.rgb;
}