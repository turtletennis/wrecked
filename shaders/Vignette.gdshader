shader_type canvas_item;

uniform float visible_radius : hint_range(0.0, 1.0);
uniform float softness : hint_range(0.001, 1.0) = 0.2;
uniform vec4 vignette_color : source_color = vec4(0.02, 0.05, 0.15, 1.0);

void fragment() {
    vec2 center = vec2(0.5);
    float dist = distance(UV, center) / 0.70710678;

    float vignette = smoothstep(
        visible_radius,
        visible_radius + softness,
        dist
    );

    COLOR = vec4(
        vignette_color.rgb * vignette,
        vignette * vignette_color.a
    );
}
