#include "constants.h"

Texture2D tex;
SamplerState textureSampler;

float4 RGB(float R, float G, float B) {
    return float4(
        R / 255.0,
        G / 255.0,
        B / 255.0,
        1.0
    );
}

float4 ColorArray[4];

float4 main(float2 uv : TexCoord) : SV_Target {
    float textureSample = tex.Sample(textureSampler, uv).r;
    float4 result = textureSample / (STATES - 1);
    return result;
}