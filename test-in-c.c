
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <stdint.h>


/*

[100][011][000][110][000]1
0111222333444555

[101][101][100][100][000]0


[1.00][1.10][0.11][0.00][1.00][0.00][0.__]
*/






// clear && gcc test-in-c.c -o test-in-c -O3 && ./test-in-c
#define do10(a) a a a a a a a a a a
#define do100(a) do10(a) do10(a) do10(a) do10(a) do10(a) do10(a) do10(a) do10(a) do10(a) do10(a)
/*
 0x0802080 0x00a8820 0x0500441 0x1015100 0x0040014 0x220020a
*/
uint32_t sepBy2Only26Bits(uint32_t n) {
    register uint32_t
        a = n & 0x0802080,
        b = n & 0x00a8820,
        c = n & 0x0500441,
        d = n & 0x1015100,
        e = n & 0x0040014,
        f = n & 0x220020a;
    return ( (a * a) | (b * b) | (c * c) | (d * d) | (e * e) | (f * f) ) & 0x55555555555555;
}

uint32_t morton26(uint32_t x, uint32_t y) {
    y <<= 1;
    register uint32_t
        a = x & 0x0802080,
        b = x & 0x00a8820,
        c = x & 0x0500441,
        d = x & 0x1015100,
        e = x & 0x0040014,
        f = x & 0x220020a,

        g = y & 0x4110004,
        h = y & 0x1044040,
        i = y & 0x0202002,
        j = y & 0x0888208,
        k = y & 0x0401510,
        l = y & 0x20208a0;
    return
        ( ( (a * a) | (b * b) | (c * c) | (d * d) | (e * e) | (f * f) ) & 0x55555555555555 ) |
        ( ( (g * g) | (h * h) | (i * i) | (j * j) | (k * k) | (l * l) ) & 0xaaaaaaaaaaaaaa );
}

uint32_t morton32(uint32_t x, uint32_t y) {
    return sepBy2Only32Bits(x) | (sepBy2Only32Bits(y) << 1);
}


int sepBy2Only26Bitso(int n) {
    register int a, b, c, d, e, f;
    a = n & 0x0802080; a = a * a;
    b = n & 0x00a8820; b = b * b;
    c = n & 0x0500441; c = c * c;
    d = n & 0x1015100; a |= d * d;
    e = n & 0x0040014; b |= e * e;
    f = n & 0x220020a; c |= f * f;
    return (a | b | c) & 0x55555555555555;
}

















uint32_t sepBy2Only32Bits(uint32_t n) {
    n = (n | n << 16) & 0x0000FFFF;
    n = (n | n << 8) & 0x00FF00FF;
    n = (n | n << 4) & 0x0F0F0F0F;
    n = (n | n << 2) & 0x33333333;
    n = (n | n << 1) & 0x55555555;
    return n;
}



















#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

// ... (Insert the sepBy2Only26Bits and sepBy2Only32Bits functions here) ...

double time_diff(struct timeval x , struct timeval y) {
    return (double)(y.tv_sec - x.tv_sec) * 1000000.0 + (double)(y.tv_usec - x.tv_usec);
}

int main() {
    const uint32_t NUM_TESTS = 100000000; // Large number of test iterations
    uint32_t *testData = malloc(NUM_TESTS * sizeof(uint32_t));

    srand(time(NULL));
    for (uint32_t i = 0; i < NUM_TESTS; ++i) {
        testData[i] = rand();
    }

    struct timeval start, end;
    volatile uint32_t result = 0;
    double total;


    for(int m = 0; m < 10; m++){
        total = 0;
        gettimeofday(&start, NULL);
        // Test sepBy2Only26Bits
        for (uint32_t i = 0; i < NUM_TESTS;) {
            do100(result += sepBy2Only26Bits(testData[i]);i++;)
            do100(result += sepBy2Only26Bits(testData[i]);i++;)
            do100(result += sepBy2Only26Bits(testData[i]);i++;)
            do100(result += sepBy2Only26Bits(testData[i]);i++;)
        }
        gettimeofday(&end, NULL);
        total += time_diff(start, end);
        printf("Total time for sepBy2Only26Bits: %f microseconds\n", total);


        total = 0;
        gettimeofday(&start, NULL);
        // Test sepBy2Only32Bits
        for (uint32_t i = 0; i < NUM_TESTS;) {
            do100(result += sepBy2Only32Bits(testData[i]);i++;)
            do100(result += sepBy2Only32Bits(testData[i]);i++;)
            do100(result += sepBy2Only32Bits(testData[i]);i++;)
            do100(result += sepBy2Only32Bits(testData[i]);i++;)
        }
        gettimeofday(&end, NULL);
        total += time_diff(start, end);
        printf("Total time for sepBy2Only32Bits: %f microseconds\n", total);

        total = 0;
        gettimeofday(&start, NULL);
        // Test sepBy2Only32Bits
        for (uint32_t i = 0; i < NUM_TESTS;) {
            do100(result += sepBy2Only26Bitso(testData[i]);i++;)
            do100(result += sepBy2Only26Bitso(testData[i]);i++;)
            do100(result += sepBy2Only26Bitso(testData[i]);i++;)
            do100(result += sepBy2Only26Bitso(testData[i]);i++;)
        }
        gettimeofday(&end, NULL);
        total += time_diff(start, end);
        printf("Total time for sepBy2Only26Bitso: %f microseconds\n", total);

        printf("=========\n\n");
    }



    printf("Result (to prevent optimization): %d\n", result);
    free(testData);
    return 0;
}
