#include "constants.h"

cbuffer Constants {
    uint ColorsEnabled;
    float4 Colors[STATE_COMBOS];
}

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

float4 main(float2 uv : TexCoord) : SV_Target {
    float textureSample = tex.Sample(textureSampler, uv).r;
    float4 result;
    if (ColorsEnabled == 0) {
        result = textureSample / (STATES - 1);
    } else {
        result = Colors[(uint)textureSample];
    }
    return result;
}