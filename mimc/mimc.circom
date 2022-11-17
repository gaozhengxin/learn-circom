pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/mimc.circom";

template hash(N) {
    signal input in[N];
    signal input commitment;
    signal output hash;

    component mimc = MultiMiMC7(N, 91);

    mimc.in <== in;
    mimc.k <== 0;
    hash <== mimc.out;
    commitment === hash;
}

component main = hash(1);