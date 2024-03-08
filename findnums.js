const n = BigInt("0b01010101010101010101010101010101010101010101010101010101010101");
function isCorrect(num){
    return num.toString(2).split("").join("0") == ((num*num)&n).toString(2);
}
function listIsCorrect(l){
    return isCorrect(l.map(ee => BigInt(1) << BigInt(ee)).reduce((a,b)=>a|b,BigInt(0)))
}










function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}


let f;
do{
    f = [];
    const r = new Set(".".repeat(26).split("").map((_,i)=>BigInt(i + 1)));
    while([...r.values()].length>0){
        const l = [];
        for(const e of shuffleArray([...r.values()])){
            l.push(e);
            if(listIsCorrect(l)) {
                r.delete(e);
            } else {
                l.pop();
            }
        }
        f.push(l);
    }
}while(f.length > 6);




const sadhkfa = f.map(e=>(e.map(ee => BigInt(1) << BigInt(ee)).reduce((a,b)=>a|b,BigInt(0))));
console.log(sadhkfa);
for(const tttt of sadhkfa){
    let even = null;
    tttt.toString(2).split("").forEach((e,i)=>{
        if(e == 1){
            if(i % 2 == 0){
                if(even === false){
                    throw new Error(`shit and die\n ${tttt.toString(2).split("").map((e,i)=>i+" : "+e).join("\n")}`);
                }
                even = true;
            }
            else {
                even = false;
            }
        }
    })



}
console.log(`
function sep2f26(n){
    let a,b,c,d,e,f;
    a = n & 0x${sadhkfa.pop().toString(16)}n; a = a * a;
    b = n & 0x${sadhkfa.pop().toString(16)}n; b = b * b;
    c = n & 0x${sadhkfa.pop().toString(16)}n; c = c * c;
    d = n & 0x${sadhkfa.pop().toString(16)}n; a = a | (d * d);
    e = n & 0x${sadhkfa.pop().toString(16)}n; b = b | (e * e);
    f = n & 0x${sadhkfa.pop().toString(16)}n; c = c | (f * f);
    return (a | b | c) & 0x5555555555555555n;
}
`)















function sep2f26(n){
    let a,b,c,d,e,f;
    a = n & 0x0040014n; a = a * a;
    b = n & 0x0802080n; b = b * b;
    c = n & 0x0500441n; c = c * c;
    d = n & 0x220020an; a = a | (d * d);
    e = n & 0x00a8820n; b = b | (e * e);
    f = n & 0x1015100n; c = c | (f * f);
    return (a | b | c) & 0x5555555555555555n;
}

console.log(0b110101011n.toString(2))
console.log(sep2f26(0b110101011n).toString(2))//10100010001000101
console.log(0b1111111011011111011111n.toString(2))
console.log(sep2f26(0b1111111011011111011111n).toString(2))//1010101010101000101000101010101000101010101

// //./wabt/build/wat2wasm current.wat
