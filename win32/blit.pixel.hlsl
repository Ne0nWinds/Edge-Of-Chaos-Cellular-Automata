
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

    float inc = 1.0 / 1024.0;
    float textureSample1 = tex.Sample(textureSampler, uv + float2(inc, 0.0)).r;
    float textureSample2 = tex.Sample(textureSampler, uv + float2(-inc, 0.0)).r;
    float textureSample3 = tex.Sample(textureSampler, uv + float2(0.0, inc)).r;
    float textureSample4 = tex.Sample(textureSampler, uv + float2(0.0, -inc)).r;

    float neighbors =
        textureSample1 * 0.25 +
        textureSample2 * 0.25 +
        textureSample3 * 0.25 +
        textureSample4 * 0.25;
    float result = textureSample * 0.6 + neighbors * 0.4;
    float4 output = lerp(RGB(192, 192, 192), RGB(10 * 2, 10 * 2, 10 * 2), smoothstep(0.375, 0.0, result));
    return output;
}