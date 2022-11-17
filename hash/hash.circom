pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template VerifyPoseidon(N) {
    signal input in[N];
    signal out[5];
    signal input commitment[5];
    component pEx = Poseidon(N, 5);
    pEx.inputs <== in;
    pEx.initialState <== 0;
    pEx.out --> out;
    out === commitment;
}

component main = VerifyPoseidon(4);
//component main = PoseidonEx(3,4);