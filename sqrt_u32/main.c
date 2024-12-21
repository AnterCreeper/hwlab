#include <stdio.h>
#include <stdlib.h>

#define STAGE 8
#define SHIFT 0

//#define DEBUG 0

int isqrt(int z, int iter) {
	const double factor = __builtin_pow(2.0, 32.0);

#ifdef DEBUG
	printf("z:%d\n", z);
#endif

	int len = __builtin_clz(z);
	if(z == 0) return 0; //__builtin_clz will return 31 if input equals to zero.

	//convert a=b(1.????)*2^a
	int index;
	unsigned int a = 31 - len;
	unsigned int b = z << len;
#ifdef DEBUG
	printf("a:%ld b:%lf\n", a, (double)b*2.0/factor);
#endif

	//generate kk
/*
	index = 4;
	double k = 1.0;
	for(int i = 1; i < iter + 1; i++){
		k = k / (1.0 - pow(2.0, -2*i));
		if(i == index) {
			k = k / (1.0 - pow(2.0, -2*i));
			index = 3 * index + 1;
		}
	}
*/
//	k = k * pow(2.0, 31+SHIFT);
//#ifdef DEBUG
//	printf("k:%lf\n", k);
//#endif

//	long long kk = k;
	long long kk = 0xbaa11c87;

	int s2 = a % 2;
	long long x = ((unsigned long long)b << (s2+SHIFT)) + kk;
	long long y = ((unsigned long long)b << (s2+SHIFT)) - kk;
#ifdef DEBUG
	printf("x:%lf y:%lf\n", ((double)x)/factor, ((double)y)/factor);
#endif

	//iter
	index = 4;
	for(int i = 1; i < iter + 1; i++){
		long long nx,ny;
                if(y < 0) {
                        nx = x + (y >> i);
                        ny = y + (x >> i);
                } else {
                        nx = x - (y >> i);
                        ny = y - (x >> i);
                }
                x = nx;
                y = ny;
		//test(nx, ny);
#ifdef DEBUG
		printf("nx:%lf ny:%lf\n", ((double)nx)/factor, ((double)ny)/factor);
#endif
		if(i == index) {
	                if(y < 0) {
        	                nx = x + (y >> i);
                	        ny = y + (x >> i);
	                } else {
        	                nx = x - (y >> i);
                	        ny = y - (x >> i);
	                }
                	x = nx;
	                y = ny;
			//test(nx, ny);
#ifdef DEBUG
			printf("nx:%lf ny:%lf\n", ((double)nx)/factor, ((double)ny)/factor);
#endif
			index = 3 * index + 1;
		}
        }

	x = x >> (32 + SHIFT - (a >> 1));

	long long zz = (unsigned int)z;
	int bit = zz < (x * x);
	return x - bit;
}

int typea = 0;
int typeb = 0;

void testing(long long x, int* count){
	//int ans = sqrt((double)x);
	int ans = __builtin_sqrt((double)x);
	int got = isqrt(x, STAGE);
	if(ans != got) {
//	if(abs(ans - got) != 1) {
		(*count)++;
		int t = ans > got;
		if(t) {
			typea++;
		} else typeb++;
		printf("i:%ld a:%d x:%d\n", x, ans, got);
//	}
	}
//		printf("i:%ld a:%d x:%d\n", x, ans, got);
	return;
}

#define RANGE 512

int main(){
	int count = 0;
	unsigned long long m = 1;
	unsigned long long j = 1;
	int k = 0;
	for(unsigned long long i = 0; i < 4294967296; i++) {
		testing(i, &count);
		j = j == 10000000 ? 1 : j + 1;
		if(j == 10000000) {
			printf("%d000000 done.\n", ++k);
		}
	}
/*	for(int i = 0; i < 65536; i = i + 1) {
		for(int j = -RANGE; j < RANGE + 1; j++) {
			long long ind = i * i + j;
			if(ind > 0) testing(ind, &count);
		}
//		printf("%d done.\n", i);
	}*/
//	testing(0x77DFEC44, &count);

	printf("error total %d\n", count);
	printf("typea:%d, typeb:%d\n", typea, typeb);
	return 0;
}
