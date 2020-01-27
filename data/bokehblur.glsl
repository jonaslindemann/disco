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


// Bokeh disc.
// by David Hoskins.
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. (https://www.shadertoy.com/view/4d2Xzw)
// Modified by SolarLiner

#define USE_MIPMAP

// The Golden Angle is (3.-sqrt(5.0))*PI radians, which doesn't precompiled for some reason.
// The compiler is a dunce I tells-ya!!
#define GOLDEN_ANGLE 2.39996323

#define ITERATIONS 512

#define DISTORTION_ANAMORPHIC	0.6;
#define DISTORTION_BARREL		0.6;
// Helpers-----------------------------------------------------------------------------------
vec2 rotate(vec2 vector, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    
    return vec2(c*vector.x-s*vector.y, s*vector.x+c*vector.y);
}

mat2 rotMatrix(float angle)
{
    return mat2(cos(angle), sin(angle),
                    -sin(angle), cos(angle));
}

// Additions by SolarLiner ------------------------------------------------------------------
vec2 GetDistOffset(vec2 uv, vec2 pxoffset)
{
    vec2 tocenter = uv.xy+vec2(-0.5,0.5);
    vec3 prep = normalize(vec3(tocenter.y, -tocenter.x, 0.0));
    
    float angle = length(tocenter.xy)*2.221*DISTORTION_BARREL;
    vec3 oldoffset = vec3(pxoffset,0.0);
    float anam = 1.0-DISTORTION_ANAMORPHIC; // Prevents a strange syntax error
    oldoffset.x *= anam;
    
    vec3 rotated = oldoffset * cos(angle) + cross(prep, oldoffset) * sin(angle) + prep * dot(prep, oldoffset) * (1.0-cos(angle));
    
    return rotated.xy;
}

//-------------------------------------------------------------------------------------------
vec3 Bokeh(sampler2D tex, vec2 uv, float radius, float amount)
{
	vec3 acc = vec3(0.0);
	vec3 div = vec3(0.0);
    vec2 tocenter = uv.xy+vec2(-0.5,0.5);
    vec2 pixel = 1.0 / iResolution.xy;
    float r = 1.0;
    vec2 vangle = vec2(0.0,radius); // Start angle
    mat2 rot = rotMatrix(GOLDEN_ANGLE);
    
    amount += radius*500.0;
    
	for (int j = 0; j < ITERATIONS; j++)
    {  
        r += 1. / r;
	    vangle = rot * vangle;
        // (r-1.0) here is the equivalent to sqrt(0, 1, 2, 3...)
        vec2 pos = GetDistOffset(uv, pixel*(r-1.)*vangle);
        
        #ifdef USE_MIPMAP
		vec3 col = texture(tex, uv + pos, radius*1.25).xyz;
        #else
        vec3 col = texture(tex, uv + pos).xyz;
        #endif
        col = col * col * 1.5; // ...contrast it for better highlights - leave this out elsewhere.
		vec3 bokeh = pow(col, vec3(9.0)) * amount+.4;
		acc += col * bokeh;
		div += bokeh;
	}
	return acc / div;
}

//-------------------------------------------------------------------------------------------
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    float time = iTime*.2 + .5;
	float r = .5 - .5*cos(time * 6.283);
       
	float a = 40.0;
    
    /*
    if (iMouse.w >= 1.0)
    {
    	r = (iMouse.x/iResolution.x)*3.0;
        a = iMouse.y/iResolution.y * 50.0;
    }
    */
    
    uv *= vec2(1.0, -1.0);
    
		fragColor = vec4(Bokeh(iChannel0, uv, r, a), 1.0);
    
    //fragColor.xyz = BarrelDistOffset(uv).xyz;
}