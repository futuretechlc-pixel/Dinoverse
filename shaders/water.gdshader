shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 shallow_color : source_color = vec4(0.12, 0.47, 0.39, 0.82);
uniform vec4 deep_color : source_color = vec4(0.018, 0.13, 0.15, 0.94);
uniform float wave_scale = 2.8;
uniform float wave_speed = 0.32;
uniform float ripple_strength = 0.075;

void vertex() {
    float t = TIME * wave_speed;
    float w1 = sin(VERTEX.x * wave_scale + t) * 0.035;
    float w2 = cos(VERTEX.z * wave_scale * 0.72 - t * 1.27) * 0.028;
    VERTEX.y += w1 + w2;
}

void fragment() {
    float t = TIME * wave_speed;
    vec2 uv = UV * wave_scale;
    float ripple = sin(uv.x * 4.0 + t) * cos(uv.y * 3.0 - t * 0.8);
    vec3 col = mix(deep_color.rgb, shallow_color.rgb, clamp(0.52 + ripple * 0.18, 0.0, 1.0));
    ALBEDO = col;
    METALLIC = 0.28;
    ROUGHNESS = 0.19 + abs(ripple) * ripple_strength;
    SPECULAR = 0.82;
    ALPHA = mix(deep_color.a, shallow_color.a, 0.5);
}
