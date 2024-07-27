#pragma once
#include "base.h"

static inline u32 PopCount32(u32 Value);
static inline u64 PopCount64(u32 Value);

static inline u32 RoundUp32(u32 Value, u32 PowerOf2) {
	Assert(PopCount32(PowerOf2) == 1);
	u32 PW2MinusOne = PowerOf2 - 1;
	Value += PW2MinusOne;
	Value &= ~PW2MinusOne;
	return Value;
}

static inline u64 RoundUp64(u64 Value, u64 PowerOf2) {
	Assert(PopCount64(PowerOf2) == 1);
	u64 PW2MinusOne = PowerOf2 - 1;
	Value += PW2MinusOne;
	Value &= ~PW2MinusOne;
	return Value;
}

typedef f32 f32x2 __attribute__((vector_size(2 * sizeof(f32))));
typedef f32 f32x4 __attribute__((vector_size(4 * sizeof(f32))));
typedef union {
	struct {
		f32 X, Y;
	};
	f32x2 Vector;
} v2;
typedef union {
	struct {
		f32 X, Y, Z;
	};
	f32x4 Vector;
} v3;
typedef union {
	struct {
		f32 X, Y, Z, W;
	};
	f32x4 Vector;
} v4;

#define MATHCALL static inline

MATHCALL v2 V2_Splat(f32 Value);
MATHCALL v2 V2(f32 X, f32 Y);
MATHCALL v2 V2_Normalize(v2 Value);

MATHCALL v3 V3_Splat(f32 Value);
MATHCALL v3 V3(f32 X, f32 Y, f32 Z);
MATHCALL v3 V3_Normalize(v3 Value);

MATHCALL v4 V4_Splat(f32 Value);
MATHCALL v4 V4(f32 X, f32 Y, f32 Z, f32 W);
MATHCALL v4 V4_Normalize(v4 Value);


/* == Vector Math == */
#if defined(CPU_X64)

#include <immintrin.h>

static inline v3 V3FromXMM(__m128 XMM) {
	v3 Result;
	_mm_store_ps(&Result.X, XMM);
	return Result;
}
static inline v4 V4FromXMM(__m128 XMM) {
	v4 Result;
	_mm_store_ps(&Result.X, XMM);
	return Result;
}

MATHCALL v2 V2_Splat(f32 Value) {
	__m128d XMM = _mm_castps_pd(_mm_broadcast_ss(&Value));
	v2 Result;
	_mm_store_pd1((f64 *)&Result, XMM);
	return Result;
}
MATHCALL v2 V2(f32 X, f32 Y) {
	v2 Result;
	Result.X = X;
	Result.Y = Y;
	return Result;
}

MATHCALL v3 V3_Splat(f32 Value) {
	__m128 XMM = _mm_broadcast_ss(&Value);
	return V3FromXMM(XMM);
}
MATHCALL v3 V3(f32 X, f32 Y, f32 Z) {
	__m128 XMM = _mm_set_ps(0.0f, Z, Y, X);
	return V3FromXMM(XMM);
}
MATHCALL v3 V3_Div(v3 A, v3 B) {
	v3 Result;
	Result.X = A.X / B.X;
	Result.Y = A.Y / B.Y;
	Result.Z = A.Z / B.Z;
	return Result;
}
MATHCALL v3 V3_Normalize(v3 Value) {
	f32 Length = Value.X*Value.X + Value.Y*Value.Y + Value.Z*Value.Z;
	if (Length > 0.0f) {
		return V3_Div(Value, V3_Splat(Length));
	}
	return V3_Splat(0.0f);
}

MATHCALL v4 V4_Splat(f32 Value) {
	__m128 XMM = _mm_broadcast_ss(&Value);
	return V4FromXMM(XMM);
}
MATHCALL v4 V4(f32 X, f32 Y, f32 Z, f32 W) {
	__m128 XMM = _mm_set_ps(W, Z, Y, X);
	return V4FromXMM(XMM);
}

static inline u32 PopCount32(u32 Value) {
	return _mm_popcnt_u32(Value);
}
static inline u64 PopCount64(u32 Value) {
	return _mm_popcnt_u64(Value);
}


#elif defined(CPU_WASM)

#else
	#error "math.h not supported on this platform
#endif