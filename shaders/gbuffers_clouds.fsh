#version 120
/* MakeUp Ultra Fast - gbuffers_clouds.fsh
Render: sky, clouds

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NO_SHADOWS

#include "/lib/config.glsl"
#include "/lib/color_utils.glsl"

// Varyings (per thread shared variables)
varying vec2 texcoord;
varying vec4 tint_color;
varying float fog_density_coeff;
varying float frog_adjust;

// 'Global' constants from system
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;
uniform sampler2D texture;
uniform float rainStrength;
uniform float far;
uniform float near;

#include "/lib/depth.glsl"

void main() {
  vec4 block_color = texture2D(texture, texcoord) * tint_color;

  #include "/src/cloudfinalcolor.glsl"
  #include "/src/writebuffers.glsl"
}
