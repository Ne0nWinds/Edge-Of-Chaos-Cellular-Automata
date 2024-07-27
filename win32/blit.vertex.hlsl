struct VSOut {
    float2 uv : TexCoord;
    float4 pos : SV_Position;
};

VSOut main(float2 position: POSITION, float2 uv: UV) {
    VSOut result;
    result.pos = float4(position.x, position.y, 0.0, 1.0);
    result.uv = uv;
    return result;
}