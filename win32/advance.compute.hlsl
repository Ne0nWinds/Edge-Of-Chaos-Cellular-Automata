#include "constants.h"

cbuffer Constants {
    uint Row;
    float Time;
    int TextureSize;
    float RandomSeed;
    uint LookupTable[8];
};

RWTexture2D<float> texture1 : register(u0);

int AccessTexture(float x, float y) {
    if (x < 0) x += TextureSize;
    float2 index = float2(x % TextureSize, y);
    float result = texture1[index];
    return result;
}

[numthreads(128,1,1)]
void main(uint3 id : SV_DispatchThreadID) {
    const uint states = STATES;
    const int search_range = SEARCH_RANGE;

    uint index = 0;
    // int multiplier = STATE_COMBOS / states;
    // for (int i = -search_range; i < search_range; ++i) {
    //     index += AccessTexture(id.x - i, Row - 1) * multiplier;
    //     multiplier /= states;
    // }
    index += (AccessTexture(id.x - 1, Row - 1)) == 0 ? 0 : 4;
    index += (AccessTexture(id.x + 0, Row - 1)) == 0 ? 0 : 2;
    index += (AccessTexture(id.x + 1, Row - 1)) == 0 ? 0 : 1;

    float final_state = LookupTable[index];
    texture1[float2(id.x, Row)] = final_state;
}