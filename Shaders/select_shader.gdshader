shader_type canvas_item;

uniform vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_size : hint_range(0.0, 0.1) = 0.01;

void vertex() {
    // No changes to the vertex shader for 2D
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    vec2 center = vec2(TEXTURE_PIXEL_SIZE.x / 3.0, TEXTURE_PIXEL_SIZE.y / 3.0);
    
    vec4 sprite_color = texture(TEXTURE, uv);

    // Calculate distance from the center
    float distance = length(uv - center);

    // Outline effect
    vec4 outline = vec4(0.0);

    for (float i = 0.0; i < 360.0; i += 1.0) {
        float angle = radians(i);
        vec2 offset = vec2(cos(angle), sin(angle)) * outline_size;
        outline += texture(TEXTURE, uv + offset);
    }

    // Combine the original sprite color with the outline
    vec4 result = mix(sprite_color, outline_color, step(0.01, sprite_color.a));
    
    // Make the center transparent based on distance
    result.a *= smoothstep(0.1, 0.5, distance);

    COLOR = result;
}
