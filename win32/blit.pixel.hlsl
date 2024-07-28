
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
    float4 result = 0.0f;
    switch (textureSample) {
        case 0.0: {
            result = RGB(0.0, 0.0, 0.0);
            break;
        }
        case 1.0: {
            result = RGB(0.0, 255.0, 0.0);
            break;
        }
        case 2.0: {
            result = RGB(0.0, 0.0, 255.0);
            break;
        }
        case 3.0: {
            result = RGB(255.0, 255.0, 255.0);
            break;
        }
    }
    return result;
}