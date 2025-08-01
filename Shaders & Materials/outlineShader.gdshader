shader_type canvas_item;

// Controls colour and thickness for outline
uniform vec4 outlineColor : source_color = vec4( 1.0, 0.0, 0.0, 1.0);
uniform float outlineThickness : hint_range( 1.0, 8.0 ) = 1.0;

float isSolid( float value ) {
	return max( 0.0, sign( value ) );
}

float hasSolidNeighbour( sampler2D textureSample, vec2 uvCoord, vec2 pixelSize ) {
	vec2 offset = outlineThickness * pixelSize;
	float sumAlpha = texture( textureSample, uvCoord + vec2( 1.0, 0.0 ) * offset ).a + 
			texture( textureSample, uvCoord + vec2( -1.0, 0.0 ) * offset ).a + 
			texture( textureSample, uvCoord + vec2( 0.0, 1.0 ) * offset ).a +
			texture( textureSample, uvCoord + vec2( 0.0, -1.0 ) * offset ).a;
	return isSolid( sumAlpha );
}

void fragment() {
	// Called for every pixel the material is visible on
	// Skip processing if already solid
	if( COLOR.a == 0.0 ) {
		float outlineMask = hasSolidNeighbour( TEXTURE, UV, TEXTURE_PIXEL_SIZE );
		if( outlineMask > 0.0 ) {
			COLOR = outlineColor;
		}
	}
}
