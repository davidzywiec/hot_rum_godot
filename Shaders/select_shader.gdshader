shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform bool apply_outline = false;

void fragment(){
    vec4 sprite_color = texture(TEXTURE, UV);
    if (apply_outline) {
        float size_x = 0.05/float(textureSize(TEXTURE, 0).x);
        float size_y = 0.05/float(textureSize(TEXTURE, 0).y);
        float alpha = -7.6 * sprite_color.a;
        alpha += texture(TEXTURE, UV + vec2(size_x, 0)).a;
        alpha += texture(TEXTURE, UV + vec2(-size_x, 0)).a;
        alpha += texture(TEXTURE, UV + vec2(0, size_y)).a;
        alpha += texture(TEXTURE, UV + vec2(0, -size_y)).a;
        alpha += texture(TEXTURE, UV + vec2(size_x, size_y)).a;
        alpha += texture(TEXTURE, UV + vec2(-size_x, size_y)).a;
        alpha += texture(TEXTURE, UV + vec2(-size_x, -size_y)).a;
        alpha += texture(TEXTURE, UV + vec2(size_x, -size_y)).a;
        vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
        COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
    } else {
        COLOR = sprite_color;
    }
}