shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.95, 0.7, 1.0);
uniform float thickness = 2.0;    // Outline thickness in pixels
uniform float point_size = 0.04;  // Width of the traveling point
uniform float glow_strength = 1.5;

uniform float speed = 5555;        // Multiplier applied to custom_time
uniform float custom_time = 0.0;  // Time fed from script

void fragment() {
    vec2 uv = UV;
    vec4 base = texture(TEXTURE, uv);

    float alpha = base.a;
    float outline = 0.0;

    // Alpha-based edge detection
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * thickness * TEXTURE_PIXEL_SIZE;
            outline = max(outline, texture(TEXTURE, uv + offset).a);
        }
    }

    float edge = clamp(outline - alpha, 0.0, 1.0);

    // Map UV to angle around logo center
    vec2 centered = uv - vec2(0.5);
    float angle = atan(centered.y, centered.x);
    float angle_norm = fract((angle + PI) / (2.0 * PI));

    // Moving single point controlled by script's time
    float t = fract(custom_time * speed);
    float spark = smoothstep(point_size, 0.0, abs(angle_norm - t));

    vec4 glow = glow_color * edge * spark * glow_strength;

    COLOR = base + glow;
}