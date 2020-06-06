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

const float PI = 3.14159;
const float ANGLE_C = 15.;
const float ANGLE_M = 75.;
const float ANGLE_Y = 0.;
const float ANGLE_K = 45.;
const float INIT_FREQ = 1600.;
const float FREQ_SINE_FACTOR = 0.09;
const float FREQ_SINE_FREQ = 0.2;
const float ROTATION_SPEED = 0.6;

const int AA_SAMPLES = 4;
const float AA_WIDTH = 0.2;

void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}

vec2 rotateVec(vec2 vect, float angle)
{
    float xr = vect.x*cos(angle) + vect.y*sin(angle);
    float yr = vect.x*sin(angle) - vect.y*cos(angle);
    return vec2(xr, yr);
}

vec4 rgb2cmyk(vec4 i)
{
   vec3 cmy = 1. - i.rgb;
   float k;
   k = min(cmy.x, min(cmy.y, cmy.z));
   
   if (k==1.) 
      cmy = vec3(0.);
   else
      cmy = (cmy - k)/(1. - k);
   
   return vec4(cmy, k);
}

float halftone(vec2 fragCoord, float im, float freq, float angle)
{
    vec2 uv = fragCoord.xy / iResolution.xx;
    //float oa = ROTATION_SPEED*iTime;
    float oa = 40.*iMouse.y/iResolution.y;
    uv = rotateVec(uv, (angle + oa)*PI/180.);
    float sp;
    float v;
    float vs = 0.;
    for (int j=0;j<AA_SAMPLES ;j++)
    {
       float oy = float(j)*AA_WIDTH;
       for (int i=0;i<AA_SAMPLES ;i++)
       {
          float ox = float(i)*AA_WIDTH;
          sp=(1.+sin(freq*uv.x + ox)+1.+sin(freq*uv.y + oy))/4.;
          vs+= im>sp?1.:0.;
       }
    }
    vs/= float(AA_SAMPLES*AA_SAMPLES);
    return vs;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    //float ff = 1. - FREQ_SINE_FACTOR*(1.+ sin(iTime*FREQ_SINE_FREQ));
    float ff = 1. - FREQ_SINE_FACTOR*(1.+ 5.*iMouse.x/iResolution.x);
    float freq = INIT_FREQ*ff;
    
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 i = texture(iChannel0,uv);
    vec4 ii = rgb2cmyk(i);
    
    float hc = halftone(fragCoord, ii.x, freq, ANGLE_C);
    float hm = halftone(fragCoord, ii.y, freq, ANGLE_M);
    float hy = halftone(fragCoord, ii.z, freq, ANGLE_Y);
    float hk = halftone(fragCoord, ii.w, freq, ANGLE_K);
    
    fragColor = vec4(1. - (vec3(hc, hm, hy)*(1. - hk) + hk), 1.0);
}