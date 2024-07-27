
cbuffer Constants {
    uint Row;
    float Time;
};

RWTexture2D<float> texture1 : register(u0);

float random(float n) {
    return frac(cos(n + Time * 1789.69283897) * 5781.3912490889914);
}

#define STATES 2
#define SEARCH_RANGE 1
// #define NEIGHBORHOOD_SIZE (STATES * 2 + 1)

[numthreads(128,1,1)]
void main(uint3 id : SV_DispatchThreadID) {
    const uint states = STATES;
    const int search_range = SEARCH_RANGE;

    // STATES ^ NEIGHBORHOOD_SIZE
    const uint lookup_table[8] = {
        0, 1, 1, 0,
        1, 0, 0, 1
    };

    uint index = 0;
    index += (texture1[float2(id.x - 1, Row - 1)]) == 1.0 ? 4 : 0;
    index += (texture1[float2(id.x + 0, Row - 1)]) == 1.0 ? 2 : 0;
    index += (texture1[float2(id.x + 1, Row - 1)]) == 1.0 ? 1 : 0;

    float final_state = lookup_table[index];
    texture1[float2(id.x, Row)] = final_state;
}