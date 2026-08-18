shader_type spatial;

uniform sampler2D snow_depth_texture : hint_default_black;
uniform float height_offset = 0.0;

void vertex() {
	VERTEX.y = height_offset + texture(snow_depth_texture, UV).r;
	
}

void fragment() {
	ALBEDO.rgb = texture(snow_depth_texture, UV).rgb / 2.0 + 0.5;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
