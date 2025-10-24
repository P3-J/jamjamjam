shader_type spatial;

uniform vec4 color: source_color = vec4(0.7, 0.12, 0.86, 1.0);
uniform sampler2D base_texture: source_color;

group_uniforms Tiling;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_offset = vec2(0,0);
group_uniforms;


void vertex() {
	UV = UV * uv_scale.xy + uv_offset.xy;
}

void fragment() {

	vec4 vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 normal = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec3 adjusted_normal = pow(abs(normal), vec3(8.0));
	vec3 weights = adjusted_normal / (adjusted_normal.x + adjusted_normal.y + adjusted_normal.z) * 3.0;

	vec2 uv_x = vertex.zy * uv_scale;
	vec2 uv_y = vertex.xz * uv_scale;
	vec2 uv_z = vertex.xy * uv_scale;

	float use_y_up = float(normal.y > 0.0);

	vec3 color_x = texture(base_texture, uv_x).rgb * weights.x;
	vec3 color_y_up = texture(base_texture, uv_y).rgb * weights.y;
	vec3 color_y_down = texture(base_texture, uv_y).rgb * weights.y;
	vec3 color_z = texture(base_texture, uv_z).rgb * weights.z;

	ALBEDO = color.rgb * (color_x + mix(color_y_down, color_y_up, use_y_up) + color_z) / 3.0;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
}
