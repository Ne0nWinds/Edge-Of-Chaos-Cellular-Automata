#pragma once

#include "base.h"
#include "math.h"

typedef struct {
	u32 WindowWidth;
	u32 WindowHeight;
} init_params;

void OnInit(init_params *InitParams);
void OnRender();

#define KB(b) (b * 1024LLU)
#define MB(b) (KB(b) * 1024LLU)
#define GB(b) (MB(b) * 1024LLU)
#define TB(b) (GB(b) * 1024LLU)

typedef struct {
	void *Start;
	void *Offset;
	u32 Capacity;
} memory_arena;

memory_arena AllocateArenaFromOS(u32 Capacity, u64 StartingAddress);

static void *ArenaPushAligned(memory_arena *Arena, u32 Size, u32 Alignment) {
	Assert(PopCount32(Alignment) == 1);
	void *Result = (void *)RoundUp64((u64)Arena->Offset, Alignment);
	Arena->Offset = (void *)((u64)Result + Size);
	Assert((u64)Arena->Offset - (u64)Arena->Start < Arena->Capacity);
	return Result;
}

static void *ArenaPush(memory_arena *Arena, u32 Size) {
	return ArenaPushAligned(Arena, Size, 16);
}

static void ArenaPop(memory_arena *Arena, void *Ptr) {
    Assert((u64)Ptr >= (u64)Arena->Start);
    Assert((u64)Ptr < (u64)Arena->Offset);
	Arena->Offset = Ptr;
}

static void ArenaReset(memory_arena *Arena) {
	Arena->Offset = Arena->Start;
}

static memory_arena ArenaScratch(memory_arena *Arena) {
	memory_arena Result = {0};
	Result.Start = Arena->Offset;
	Result.Offset = Arena->Offset;
	Result.Capacity = Arena->Capacity - (u32)((u64)Arena->Offset - (u64)Arena->Start);
	return Result;
}