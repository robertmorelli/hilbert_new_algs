


/*
0,1 1,1
0,0 1,0




clockwise (0)
offsets links
(0)
1 2   00 00
0 3   10 12



(1)
0 1   11 01
3 2   13 01



(2)
3 0   10 12
2 1   02 02



(3)
2 3   03 11
1 0   03 13



counter-clockwise (1)
offsets
(0)
3 2   02 10
0 1   00 10



(1)
0 3   01 03
1 2   11 11



(2)
1 0   12 02
2 3   12 00



(3)
2 1   13 13
3 0   01 03



offsets:
[
[0,1,2,3]
[3,0,1,2]
[2,3,0,1]
[1,2,3,0]
[0,3,2,1]
[1,0,3,2]
[2,1,0,3]
[3,2,1,0]
]

links:
[
[4,0,0,6]
[7,5,1,1]
[2,4,6,2]
[3,3,5,7]
[0,2,4,4]
[5,1,3,5]
[6,6,2,0]
[1,7,7,3]
]
*/

// const ofsts = [
//     [[0, 1], [2, 3]],
//     [[3, 0], [1, 2]],
//     [[2, 3], [0, 1]],
//     [[1, 2], [3, 0]],
//     [[0, 3], [2, 1]],
//     [[1, 0], [3, 2]],
//     [[2, 1], [0, 3]],
//     [[3, 2], [1, 0]],];
// const links = [
//     [[4, 0], [0, 6]],
//     [[7, 5], [1, 1]],
//     [[2, 4], [6, 2]],
//     [[3, 3], [5, 7]],
//     [[0, 2], [4, 4]],
//     [[5, 1], [3, 5]],
//     [[6, 6], [2, 0]],
//     [[1, 7], [7, 3]],];
// function hilbertFull(x, y, s) {
//     let result = 0;
//     for (let i = 30; i >= 0; i--) {
//         result = ofsts[s][x >> i][y >> i];
//         result <<= 2;
//         s = links[s][x >> i][y >> i];
//     }
//     return result;
// }
// function hilbertClassic(x, y) {
//     return hilbertFull(x, y, 0);
// }








// function hilbertIndex(x, y) {
//     let index = 0;
//     let mask = 1 << 63;

//     for (let i = 0; i < 64; i++) {
//         let ix = (x & mask) > 0;
//         let iy = (y & mask) > 0;

//         index <<= 2;
//         index |= ((3 * ix) ^ iy);

//         let temp;
//         if (!iy) {
//             if (ix) {
//                 x = ~x;
//                 y = ~y;
//             }
//             temp = x;
//             x = y;
//             y = temp;
//         }

//         mask >>= 1;
//     }

//     return index;
// }

// const table = [
//     0, 4, 1, 0, 3, 6, 2, 0,
//     3, 7, 0, 5, 2, 1, 1, 1,
//     2, 2, 3, 4, 1, 2, 0, 6,
//     1, 3, 2, 3, 0, 7, 3, 5,
//     0, 0, 3, 2, 1, 4, 2, 4,
//     1, 5, 0, 1, 2, 5, 3, 3,
//     2, 6, 1, 6, 3, 0, 0, 2,
//     3, 1, 2, 7, 0, 3, 1, 7,];
// function hilbertFull(x, y, state, top, bot) {
//     let yh = 0, xh = 0, result = 0, index = 0;
//     while (top-- >= bot) {
//         xh = (x >> (top - 2)) & 4;
//         yh = (y >> (top - 1)) & 2;
//         index = (state << 3) | xh | yh;
//         result = table[index] | result << 2;
//         state = table[index | 1];
//     }
//     return result;
// }
// const t = { 
//     0: 0,
//      1: 8,
//      2: 16,
//      3: 24,
//      4: 32,
//      5: 40,
//      6: 48,
//      7: 56,
//      };


// const table = [
//     [[[0, 4], [1, 0]], [[3, 6], [2, 0]]],
//     [[[3, 7], [0, 5]], [[2, 1], [1, 1]]],
//     [[[2, 2], [3, 4]], [[1, 2], [0, 6]]],
//     [[[1, 3], [2, 3]], [[0, 7], [3, 5]]],
//     [[[0, 0], [3, 2]], [[1, 4], [2, 4]]],
//     [[[1, 5], [0, 1]], [[2, 5], [3, 3]]],
//     [[[2, 6], [1, 6]], [[3, 0], [0, 2]]],
//     [[[3, 1], [2, 7]], [[0, 3], [1, 7]]],];
// function hilbertFull(x, y, state, top, bot) {
//     let yh = 0, xh = 0, result = 0;
//     while (top-- >= bot) {
//         xh = (x >> top) & 1, yh = (y >> top) & 1;
//         result = table[state][xh][yh][0] | result << 2;
//         state = table[state][xh][yh][1];
//     }
//     return result;
// }


const { requireWat } = require('require-wat');
const { hClass } = requireWat('./current.wat');
console.log(hClass(2,3));
