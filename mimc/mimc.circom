pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/mimc.circom";

template hash(N) {
    signal input in[N];
    signal input hash;
    signal output hash_;

    component mimc = MultiMiMC7(N, 91);

    mimc.in <== in;
    mimc.k <== 0;
    hash_ <== mimc.out;
    hash === hash_;
}

component main = hash(2);