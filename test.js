const fs = require('node:fs');
const wasmBuffer = fs.readFileSync('./current.wasm');



const table = new BigInt64Array([
    0b00, 0b100000, 0b01, 0b000000, 0b11, 0b110000, 0b10, 0b000000,
    0b11, 0b111000, 0b00, 0b101000, 0b10, 0b001000, 0b01, 0b001000,
    0b10, 0b010000, 0b11, 0b100000, 0b01, 0b010000, 0b00, 0b110000,
    0b01, 0b011000, 0b10, 0b011000, 0b00, 0b111000, 0b11, 0b101000,
    0b00, 0b000000, 0b11, 0b010000, 0b01, 0b100000, 0b10, 0b100000,
    0b01, 0b101000, 0b00, 0b001000, 0b10, 0b101000, 0b11, 0b011000,
    0b10, 0b110000, 0b01, 0b110000, 0b11, 0b000000, 0b00, 0b010000,
    0b11, 0b001000, 0b10, 0b111000, 0b00, 0b011000, 0b01, 0b111000,
].map(e => BigInt(e)));
function hilbertFullReference(x, y, state, top, bot) {
    let yh = BigInt(0b00), xh = BigInt(0b00), result = BigInt(0b00), index = BigInt(0b00), offset = BigInt(0b00);
    do {
        top = top - BigInt(0b10);
        result = result << BigInt(0b10);
        yh = y >> top;
        top = top - BigInt(0b01);
        yh = yh & BigInt(0b10);
        xh = x >> top;
        index = state | yh;
        top = top + BigInt(0b10);
        xh = xh & BigInt(0b100);
        index = index | xh;
        offset = table[index];
        index = index | BigInt(0b01);
        result = result | offset;
        state = table[index];
    } while (top >= bot);
    return result;
}
function hilbertClassicInt64Reference(x, y) {
    return hilbertFullReference(x, y, BigInt(0b00), BigInt(62), BigInt(31));
}
mybuffer = [];
for(const e of wasmBuffer) mybuffer.push(e);
// console.log(mybuffer.map(e => "0x"+e.toString(16)).join(","))

WebAssembly.instantiate(wasmBuffer, {console,thing :{logbits: (x)=>console.log(x.toString(2))}}).then(wasmModule => {
    const {hilby,hilbys,hilbyss,sep,morty} = wasmModule.instance.exports;

    console.log((morty(BigInt("0b"+"10000000000000000000000000"),BigInt("0b"+"10000000000000000000000000")) >> 50n).toString(2));
    // console.log(0b110101011n.toString(2))
    // console.log(split(0b110101011n).toString(2))//10100010001000101
    // console.log(0b1111111011011111011111n.toString(2))
    // console.log(split(0b1111111011011111011111n).toString(2))//1010101010101000101000101010101000101010101
    console.log("==============================================");



    
    // [0,2,4,7,10,13,16,19,22,25],
    // [1,3,5,11,15,17,21,23],
    // [6,9,12,14,18],
    // [8,20,24],
    // const nnn = BigInt("0b010101010101010101010101010101010101010101010101010101010101");
    // const mmmm = [[0,2,4,8,14,19]].map(e => e.map(ee => BigInt(ee)))
    // .map(e => e.map(ee => BigInt(1) << ee).reduce((a,b)=>a|b,BigInt(0)));
    // console.log(mmmm.map(e => e.toString(2).split("1").length == (nnn&(e*e)).toString(2).split("1").length   ))


    
    console.log(0,0,":--:",hilbys(0,0),hilbyss(0,0));
    console.log(0,1,":--:",hilbys(0,1),hilbyss(0,1));
    console.log(1,0,":--:",hilbys(1,0),hilbyss(1,0));
    console.log(1,1,":--:",hilbys(1,1),hilbyss(1,1));
    console.log(0.5,0.5,":--:",hilbys(0.5,0.5),hilbyss(0.5,0.5));

    console.log(0.22,0.22,":--:",hilbys(0.22,0.22),hilbyss(0.22,0.22));
    console.log(0.33,0.33,":--:",hilbys(0.33,0.33),hilbyss(0.33,0.33));
    console.log("==============================================");





    function generateCoordinatePairs(count) {
        const pairs = [];
        for (let i = 0; i < count; i++) {
            pairs.push([Math.random(), Math.random()]);
        }
        return pairs;
    }
    
    function measurePerformance(pairs,func) {
        let totalTime = 0;
        let x, y, h;
    
        for (let i = 0; i < pairs.length; i++) {
            [x, y] = pairs[i];
    
            let startTime = performance.now();
            h = func(x, y); // Call your hilbys function here
            let endTime = performance.now();
    
            totalTime += (endTime - startTime); // Accumulate the time spent in hilbys
            
        }
    
        let opsPerSecond = pairs.length / (totalTime / 1000); // Convert ms to seconds
        console.log(`Operations per second: ${opsPerSecond}`);
    }
    
    // Generate 1 million coordinate pairs
    // throw new Error("stop")
     const coordinatePairs = generateCoordinatePairs(1000000);

     measurePerformance(coordinatePairs,hilby);
     console.log("1")
     measurePerformance(coordinatePairs,hilbys);
     console.log("2")
     measurePerformance(coordinatePairs,hilbyss);
     console.log("3")
     console.log("----");
     measurePerformance(coordinatePairs,hilby);
     console.log("1")
     measurePerformance(coordinatePairs,hilbys);
     console.log("2")
     measurePerformance(coordinatePairs,hilbyss);
     console.log("3")
     console.log("----");
     measurePerformance(coordinatePairs,hilby);
     console.log("1")
     measurePerformance(coordinatePairs,hilbys);
     console.log("2")
     measurePerformance(coordinatePairs,hilbyss);
     console.log("3")
     console.log("----");
     measurePerformance(coordinatePairs,hilby);
     console.log("1")
     measurePerformance(coordinatePairs,hilbys);
     console.log("2")
     measurePerformance(coordinatePairs,hilbyss);
     console.log("3")
     console.log("----");


     function generatePoints(n) {
        let points = [];
        for (let i = 0; i < n; i++) {
            points.push({ x: Math.random(), y: Math.random() });
        }
        return points;
    }
    
    function sortPoints(points) {
        return points.sort((a, b) => hilbyss(a.x, a.y) - hilbyss(b.x, b.y));
    }
    
    function generateSVG(points) {
        let svgPath = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">';
        svgPath += '<path d="M ' + points.map(p => `${p.x * 500} ${p.y * 500}`).join(' L ') + '" stroke="black" fill="none"/>';
        svgPath += '</svg>';
        return svgPath;
    }
    
    function createHTML() {
        let points = generatePoints(1000); // Generate 100 points
        let sortedPoints = sortPoints(points);
        let svg = generateSVG(sortedPoints);
    
        return `
            <!DOCTYPE html>
            <html>
            <head><title>Sorted Points Visualization</title></head>
            <body>${svg}</body>
            </html>
        `;
    }
    // Use this function to get the HTML code
    let htmlCode = createHTML();
    console.log(htmlCode);
    
});
