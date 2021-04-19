/* MakeUp - color_utils.glsl
Usefull data for color manipulation.

Javier Garduño - GNU Lesser General Public License v3.0
*/

uniform float day_moment;
uniform float day_mixer;
uniform float night_mixer;

#if COLOR_SCHEME == 0  // Legacy
  #define OMNI_TINT 0.5
  #define AMBIENT_MIDDLE_COLOR vec3(0.78, 0.39458823, 0.17129412)
  #define AMBIENT_DAY_COLOR vec3(0.7696, 0.7696, 0.728)
  #define AMBIENT_NIGHT_COLOR vec3(0.04080882, 0.04411765, 0.05211397)

  #define HI_MIDDLE_COLOR vec3(0.22941177, 0.45372549, 1.07568627)
  #define HI_DAY_COLOR vec3(0.182, 0.351, 0.754)
  #define HI_NIGHT_COLOR vec3(0.00647058, 0.01270587, 0.03)

  #define LOW_MIDDLE_COLOR vec3(1.3, 0.65764706, 0.28549019)
  #define LOW_DAY_COLOR vec3(0.572, 1.014, 1.248)
  #define LOW_NIGHT_COLOR vec3(0.01078431, 0.02117647, 0.05)
#elif COLOR_SCHEME == 1  // Cocoa
  #define OMNI_TINT 0.5
  #define AMBIENT_MIDDLE_COLOR vec3(0.6656, 0.4784, 0.2184)
  #define AMBIENT_DAY_COLOR vec3(0.78, 0.78, 0.49725)
  #define AMBIENT_NIGHT_COLOR vec3(0.04080882, 0.04411765, 0.05211397)

  #define HI_MIDDLE_COLOR vec3(0.117, 0.26, 0.494)
  #define HI_DAY_COLOR vec3(0.234, 0.403, 0.676)
  #define HI_NIGHT_COLOR vec3(0.014, 0.019, 0.031)

  #define LOW_MIDDLE_COLOR vec3(1.183, 0.858, 0.611)
  #define LOW_DAY_COLOR vec3(0.52, 0.975, 1.3)
  #define LOW_NIGHT_COLOR vec3(0.022, 0.029, 0.049)
#elif COLOR_SCHEME == 2  // Captain
  #define OMNI_TINT 0.5
  #define AMBIENT_MIDDLE_COLOR vec3(0.612, 0.384, 0.19200001)
  #define AMBIENT_DAY_COLOR vec3(0.76032001, 0.85535999, 1.0098)
  #define AMBIENT_NIGHT_COLOR vec3(0.02258823, 0.04517648, 0.06)

  #define HI_MIDDLE_COLOR vec3(0.30225, 0.359775, 0.519675)
  #define HI_DAY_COLOR vec3(0.104, 0.26, 0.507)
  #define HI_NIGHT_COLOR vec3(0.004 ,0.01, 0.0195)

  #define LOW_MIDDLE_COLOR vec3(1.3, 1.079, 0.494)
  #define LOW_DAY_COLOR vec3(0.65, 0.91, 1.3)
  #define LOW_NIGHT_COLOR vec3(0.025, 0.035, 0.05)
#elif COLOR_SCHEME == 3  // Shoka
  #define OMNI_TINT 0.5
  #define AMBIENT_MIDDLE_COLOR vec3(0.64, 0.46, 0.21)
  #define AMBIENT_DAY_COLOR vec3(0.9375, 0.9375, 0.65)
  #define AMBIENT_NIGHT_COLOR vec3(0.02448529, 0.02647059, 0.03126838)

  #define HI_MIDDLE_COLOR vec3(0.13, 0.22176471, 0.33137255)
  #define HI_DAY_COLOR vec3(0.13, 0.22176471, 0.33137255)
  #define HI_NIGHT_COLOR vec3(0.014, 0.019, 0.025)

  #define LOW_MIDDLE_COLOR vec3(0.715, 0.611, 0.52)
  #define LOW_DAY_COLOR vec3(0.364 , 0.6825, 0.91)
  #define LOW_NIGHT_COLOR vec3(0.0213, 0.0306, 0.0387)
#elif COLOR_SCHEME == 4  // Ethereal
  #define OMNI_TINT 0.5
  #define AMBIENT_MIDDLE_COLOR vec3(0.78, 0.39458823, 0.17129412)
  #define AMBIENT_DAY_COLOR vec3(0.7696, 0.7696, 0.728)
  #define AMBIENT_NIGHT_COLOR vec3(0.04080882, 0.04411765, 0.05211397)

  #define HI_MIDDLE_COLOR vec3(0.22941177, 0.45372549, 1.07568627)
  #define HI_DAY_COLOR vec3(0.182, 0.351, 0.754)
  #define HI_NIGHT_COLOR vec3(0.00647058, 0.01270587, 0.03)

  #define LOW_MIDDLE_COLOR vec3(1.3, 0.65764706, 0.28549019)
  #define LOW_DAY_COLOR vec3(0.572, 1.014, 1.248)
  #define LOW_NIGHT_COLOR vec3(0.01078431, 0.02117647, 0.05)
#endif

vec3 day_blend(vec3 middle, vec3 day, vec3 night) {
  // f(x) = min(−((x−.25)^2)∙20 + 1.25, 1)
  // g(x) = min(−((x−.75)^2)∙50 + 3.125, 1)

  vec3 day_color = mix(middle, day, day_mixer);
  vec3 night_color = mix(middle, night, night_mixer);

  return mix(day_color, night_color, step(0.5, day_moment));
}

// Ambient color luma per hour in exposure calculation
const float ambient_exposure[25] =
  float[25](
  1.0, // 6
  1.0, // 7
  1.0, // 8
  1.0, // 9
  1.0, // 10
  1.0, // 11
  1.0, // 12
  1.0, // 1
  1.0, // 2
  1.0, // 3
  1.0, // 4
  1.0, // 5
  1.0, // 6
  .01, // 7
  .01, // 8
  .01, // 9
  .01, // 10
  .01, // 11
  .01, // 12
  .01, // 1
  .01, // 2
  .01, // 3
  .01, // 4
  .01, // 5
  1.0 // 6
  );

// How many sky_color vs. fog_color is used for fog.
const float fog_color_mix[25] =
  float[25](
  .9, // 6
  .7, // 7
  .5, // 8
  .5, // 9
  .5, // 10
  .5, // 11
  .5, // 12
  .5, // 13
  .5, // 14
  .5, // 15
  .5, // 16
  .7, // 17
  .9, // 18
  .9, // 19
  .9, // 20
  .9, // 21
  .9, // 22
  .9, // 23
  .9, // 24
  .9, // 1
  .9, // 2
  .9, // 3
  .9, // 4
  .9, // 5
  .9 // 6
  );

// Fog parameter per hour
const float fog_density[25] =
  float[25](
  2.0, // 6
  2.5, // 7
  3.0, // 8
  3.0, // 9
  3.0, // 10
  3.0, // 11
  3.0, // 12
  3.0, // 13
  3.0, // 14
  3.0, // 15
  3.0, // 16
  2.5, // 17
  2.0, // 18
  2.25, // 19
  2.5, // 20
  3.0, // 21
  3.0, // 22
  3.0, // 23
  3.0, // 24
  3.0, // 1
  3.0, // 2
  3.0, // 3
  2.5, // 4
  2.25, // 5
  2.0 // 6
  );

// #define CANDLE_BASELIGHT vec3(0.4995, 0.38784706, 0.1998)
#define CANDLE_BASELIGHT vec3(0.24975   , 0.19392353, 0.0999)
