#include "constants.h"

struct VSOut {
    float2 uv : TexCoord;
    float4 pos : SV_Position;
};

cbuffer Constants {
    uint Row;
    float Time;
    int TextureSize;
    float RandomSeed;
    uint LookupTable[STATE_COMBOS];
};

VSOut main(float2 position: POSITION, float2 uv: UV) {
    VSOut result;
    result.pos = float4(position.x, position.y, 0.0, 1.0);
    float2 wrapped_uv = uv;
    if ((Row & (1 << 31)) == 0) {
        const uint row = (Row & 0x7FFFFFFF) + 1;
        wrapped_uv.y += row / (float)TextureSize;
    }
    result.uv = wrapped_uv;
    return result;
}