#pragma header

varying float vAlpha;
varying vec2 vTexCoord;
uniform sampler2D uImage0;

uniform int width;
uniform int height;
			
void main(void) {	
	vec4 color = texture2D(uImage0, vTexCoord);
	vec4 left = texture2D(uImage0, vTexCoord - vec2(-1.0 / width, 0));
	vec4 right = texture2D(uImage0, vTexCoord - vec2(1.0 / width, 0));
	vec4 up = texture2D(uImage0, vTexCoord - vec2(0, -1.0 / height));
	vec4 down = texture2D(uImage0, vTexCoord - vec2(0, 1.0 / height));

	float alpha = color.a;
	if (left.a > alpha) alpha = left.a;
	if (right.a > alpha) alpha = right.a;
	if (up.a > alpha) alpha = up.a;
	if (down.a > alpha) alpha = down.a;
	gl_FragColor = vec4(
		color.r * color.a,
		color.g * color.a,
		color.b * color.a,
		color.a
		);
}