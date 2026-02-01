shader_type canvas_item;

uniform vec4 screen_color : source_color = vec4(0.0, 0.0, 0.45, 1.0); // Azul suave
uniform float scanline_opacity : hint_range(0.0, 0.5) = 0.1; // Bem suave
uniform float scanline_count : hint_range(0.0, 1000.0) = 320.0;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float aberration : hint_range(0.0, 0.1) = 0.002; // Separação de cores sutil

void fragment() {
	// 1. Aberração Cromática (Cores levemente deslocadas para o efeito 'glow')
	float r = texture(TEXTURE, UV + vec2(aberration, 0.0)).r;
	float g = texture(TEXTURE, UV).g;
	float b = texture(TEXTURE, UV - vec2(aberration, 0.0)).b;
	
	// 2. Curvatura bem leve (quase imperceptível)
	vec2 centered_uv = UV * 2.0 - 1.0;
	vec2 uv_offset = centered_uv.yx * 0.02;
	vec2 curved_uv = UV + centered_uv * uv_offset * uv_offset;
	
	// 3. Scanlines suaves (usando seno elevado para linhas mais finas)
	float scanline = sin(curved_uv.y * scanline_count * 3.1415) * scanline_opacity;
	
	// 4. Cor Final
	vec3 color = screen_color.rgb;
	color -= scanline;
	
	// 5. Vinheta arredondada para suavizar as bordas
	float vignette = length(UV - 0.5);
	vignette = smoothstep(0.5, 0.8, vignette);
	color -= vignette * vignette_intensity;
	
	// Limita as bordas para não mostrar o "atrás" da curvatura
	if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = vec4(color, 1.0);
	}
}