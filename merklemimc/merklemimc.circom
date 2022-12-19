// https://github.com/tornadocash/tornado-anonymity-mining/blob/v2/circuits/MerkleTree.circom
pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/mimc.circom";

template hashLeftRight() {
    signal input in[2];
    signal output hash;

    component mimc = MultiMiMC7(2, 91);

    mimc.in <== in;
    mimc.k <== 0;
    hash <== mimc.out;
}

// if s == 0 returns [in[0], in[1]]
// if s == 1 returns [in[1], in[0]]
template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0; // 必须是 0 或 1
    // s = 0 不变，s = 1 交换顺序
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

template verifyOne(levels) {
    signal input leaf;
    signal input pathElements[levels];
    signal input pathIndices[levels]; // leaf 在左还是在右
    signal output root;

    component selectors[levels];
    component hashers[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf : hashers[i - 1].hash; // 0 的话就是 leaf, 不然就是上一个循环算出来的 hash
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = hashLeftRight();
        hashers[i].in[0] <== selectors[i].out[0];
        hashers[i].in[1] <== selectors[i].out[1];
    }

    root <== hashers[levels - 1].hash;
    // 运行 witness, root 就会算出来, 然后生成证明, root 会作为 public input 输出出来
    // 到时候要把 public input 传入 verifier 合约
    // verifier 合约必须把 root 跟真实 root 对比
}

component main = verifyOne(7); // 7 层正好