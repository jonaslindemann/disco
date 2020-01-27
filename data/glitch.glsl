uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds) (replaces iGlobalTime which is now obsolete)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iMaxDistort;

uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform vec4      iDate;                 // (year, month, day, time in seconds)

//uniform float     iChannelTime[2];
//uniform vec3      iChannelResolution[2];


// Channels can be either 2D maps or Cubemaps.
// Pick the ones you need and uncomment them.


// uniform float     iChannelTime[1..4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[1..4]; // channel resolution (in pixels)

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}


float GlitchAmount = 1.0;

vec4 posterize(vec4 color, float numColors)
{
    return floor(color * numColors - 0.5) / numColors;
}

vec2 quantize(vec2 v, float steps)
{
    return floor(v * steps) / steps;
}

float dist(vec2 a, vec2 b)
{
    return sqrt(pow(b.x - a.x, 2.0) + pow(b.y - a.y, 2.0));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{   
	vec2 uv = fragCoord.xy / iResolution.xy;
    float amount = pow(GlitchAmount, 2.0);
    vec2 pixel = 1.0 / iResolution.xy;    
    vec4 color = texture(iChannel0, uv);
    float t = mod(mod(iTime, amount * 100.0 * (amount - 0.5)) * 109.0, 1.0);
    vec4 postColor = posterize(color, 16.0);
    vec4 a = posterize(texture(iChannel0, quantize(uv, 64.0 * t) + pixel * (postColor.rb - vec2(.5)) * 100.0), 5.0).rbga;
    vec4 b = posterize(texture(iChannel0, quantize(uv, 32.0 - t) + pixel * (postColor.rg - vec2(.5)) * 1000.0), 4.0).gbra;
    vec4 c = posterize(texture(iChannel0, quantize(uv, 16.0 + t) + pixel * (postColor.rg - vec2(.5)) * 20.0), 16.0).bgra;
    fragColor = mix(
        			texture(iChannel0, 
                              uv + amount * (quantize((a * t - b + c - (t + t / 2.0) / 10.0).rg, 16.0) - vec2(.5)) * pixel * 100.0),
                    (a + b + c) / 3.0,
                    (0.5 - (dot(color, postColor) - 1.5)) * amount);
}