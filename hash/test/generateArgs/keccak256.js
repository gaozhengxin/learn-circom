const keccak256 = require('keccak256');

function bytesToBits(b) {
    const bits = [];
    for (let i = 0; i < b.length; i++) {
        for (let j = 0; j < 8; j++) {
            if ((Number(b[i]) & (1 << j)) > 0) {
                // bits.push(Fr.e(1));
                bits.push(1);
            } else {
                // bits.push(Fr.e(0));
                bits.push(0);
            }
        }
    }
    return bits
}

function stringToByteArray(s) {
    var result = new Uint8Array(s.length);
    for (var i = 0; i < s.length; i++) {
        result[i] = s.charCodeAt(i);
    }
    return result;
}

function main() {
    let input = 'aaaaa';
    let hash = keccak256(Buffer.from(input));
    let hashData = Array.prototype.slice.call(hash);
    let args = { in: bytesToBits(Array.from(stringToByteArray(input))), commitment: bytesToBits(hashData) }
    console.log(JSON.stringify(args));
    console.log(args.commitment.length);
}

main();