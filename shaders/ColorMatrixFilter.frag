//TAKEN FROM OPENFL FILTERS

#pragma header

uniform sampler2D openfl_Texture;

uniform mat4 uMultipliers;
uniform vec4 uOffsets;

void main(void) {

	vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

	if (color.a == 0.0) {
		gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
	} else {
		color = vec4 (color.rgb / color.a, color.a);
		color = uOffsets + color * uMultipliers;

		gl_FragColor = vec4 (color.rgb * color.a, color.a);
	}
}