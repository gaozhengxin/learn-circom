pragma circom 2.0.0;

include "../node_modules/keccak256-circom/circuits/keccak.circom";

template PedersenKeccak256(N) {
    signal input in[N];
    signal output out[32*8];
    component keccak256 = Keccak(N, 32*8);
    keccak256.in <-- in;
    keccak256.out ==> out;
}

component main = PedersenKeccak256(10);