#version 120
/* MakeUp Ultra Fast - gbuffers_water.vsh
Render: Water and translucent blocks

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define THE_END

#include "/lib/config.glsl"
#include "/lib/color_utils_end.glsl"

// 'Global' constants from system
uniform vec3 sunPosition;
uniform int isEyeInWater;
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;
uniform float light_mix;
uniform float far;

uniform sampler2D texture;
uniform float nightVision;
uniform float rainStrength;
uniform vec3 skyColor;
uniform ivec2 eyeBrightnessSmooth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

// Varyings (per thread shared variables)
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 tint_color;
varying vec3 real_light;
varying vec3 water_normal;
varying float block_type;
varying vec4 worldposition;
varying vec4 position2;
varying vec3 tangent;
varying vec3 binormal;

attribute vec4 mc_Entity;
attribute vec4 at_tangent;

#if AA_TYPE == 2
  #include "/src/taa_offset.glsl"
#endif

#include "/lib/basic_utils.glsl"

void main() {
  #include "/src/basiccoords_vertex.glsl"
  #include "/src/light_vertex.glsl"

  water_normal = normal;
  vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
  position2 = gl_ModelViewMatrix * gl_Vertex;
  worldposition = position + vec4(cameraPosition.xyz, 0.0);
  gl_Position = gl_ProjectionMatrix * gbufferModelView * position;

  #if AA_TYPE == 2
    gl_Position.xy += offsets[frame8] * gl_Position.w * texelSize;
  #endif

  tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
  binormal = normalize(gl_NormalMatrix * -cross(gl_Normal, at_tangent.xyz));
  gl_FogFragCoord = length(gl_Position.xyz);

  // Special entities
  block_type = 0.0;  // 3 - Water, 2 - Glass, 1 - Portal, 0 - ?
  if (mc_Entity.x == ENTITY_WATER) {  // Glass
    block_type = 3.0;
  } else if (mc_Entity.x == ENTITY_STAINED) {  // Glass
    block_type = 2.0;
  } else if (mc_Entity.x == ENTITY_PORTAL) {  // Portal
    block_type = 1.0;
  }
}
