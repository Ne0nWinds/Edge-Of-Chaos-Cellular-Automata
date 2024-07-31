void * __cdecl memset(void* dst, int ch, unsigned long long count) {
	unsigned char C = *(unsigned char *)&ch;
	unsigned char *Dst = (unsigned char *)dst;
	while (count) {
		*Dst++ = C;
		count -= 1;
	}
	return dst;
}

void * __cdecl memcpy(void * restrict dst, const void * restrict src, unsigned long long count) {
	unsigned char *d = (unsigned char *)dst;
	const unsigned char *s = (const unsigned char *)src;

	for (unsigned long long i = 0; i < count; ++i) {
		*d++ = *s++;
	}
	return dst;
}

int _fltused = 0x9875;
