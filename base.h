#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef int8_t  s8;
typedef int16_t s16;
typedef int32_t s32;
typedef int64_t s64;

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef char char8;

typedef float f32;
typedef double f64;

struct v2;
struct v3;
struct v4;

#define ArrayLength(arr) (sizeof(arr) / sizeof(*arr))

#ifndef SIMD_WIDTH
	#if defined(__AVX2__)
	    #define SIMD_WIDTH 8
	#elif defined(__SSE2__)
	    #define SIMD_WIDTH 4
	#elif defined(CPU_WASM)
	    #define SIMD_WIDTH 4
	#endif
	#ifndef SIMD_WIDTH
	    #error "SIMD_WIDTH not defined for this platform"
	#endif
#endif

#if defined(__amd64__) | defined(_M_AMD64)
	#define CPU_X64
#elif defined(__arm__) | defined(_M_ARM)
	#define CPU_ARM
#endif
// NOTE: CPU_WASM must be defined manually

#if defined(_WIN32)
	#define PLATFORM_WIN32
#elif defined(__gnu_linux__)
	#define PLATFORM_LINUX
#elif defined(__WASM__) | defined(CPU_WASM)
	#define PLATFORM_WASM
#endif

/* == Debugging == */
#if defined(_DEBUG)
    #if defined(PLATFORM_WIN32)
        #define Break() __debugbreak()
        #define Assert(Expr) if (!(Expr)) Break()
    #elif defined(PLATFORM_WASM)
        void __attribute__((import_name("__break"))) __break();
        #define Break() __break()
        #define Assert(Expr) if (!(Expr)) Break()
    #endif
#endif

#ifndef _DEBUG
    #define Break()
    #define Assert(Expr)
#endif
