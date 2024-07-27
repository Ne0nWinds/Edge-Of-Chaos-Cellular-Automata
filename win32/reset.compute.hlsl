
cbuffer Constants {
    uint Row;
    float Time;
};

RWTexture2D<float> texture1 : register(u0);

float random(float n) {
    return frac(cos(n * 1789.69283897 + Time) * 5781.3912490889914);
}

[numthreads(128,1,1)]
void main(uint3 id : SV_DispatchThreadID) {
    const uint states = 2.0;

    float2 index = float2(id.x, 0);
    texture1[index] = floor(random(id.x) * states);
}