#include "constants.h"

cbuffer Constants {
    uint Row;
    float Time;
    int TextureSize;
    uint LookupTable[64];
};

RWTexture2D<float> texture1 : register(u0);

float AccessTexture(float x, float y) {
    if (x < 0) x += TextureSize;
    float2 index = float2(x % TextureSize, y);
    return texture1[index];
}

[numthreads(128,1,1)]
void main(uint3 id : SV_DispatchThreadID) {
    const uint states = STATES;
    const int search_range = SEARCH_RANGE;

    uint index = 0;
    index += (AccessTexture(id.x - 1, Row - 1)) == 0.0 ? 4 : 0;
    index += (AccessTexture(id.x + 0, Row - 1)) == 0.0 ? 2 : 0;
    index += (AccessTexture(id.x + 1, Row - 1)) == 0.0 ? 1 : 0;

    float final_state = LookupTable[index];
    texture1[float2(id.x, Row)] = final_state;
}