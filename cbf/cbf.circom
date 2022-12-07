pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/mimc.circom";

template cbfAdd() {
    signal input in;
    signal input bitsIn[1024];
    signal output bitsOut[1024];

    var _bits_[1024];
    _bits_ = bitsIn;

    component mimc1 = MultiMiMC7(2, 5);
    component mimc2 = MultiMiMC7(2, 5);
    component mimc3 = MultiMiMC7(2, 5);
    component mimc4 = MultiMiMC7(2, 5);
    signal hash1;
    signal hash2;
    signal hash3;
    signal hash4;

    var data1[2] = [in, 0];
    mimc1.in <== data1;
    mimc1.k <== 0;
    mimc1.out ==> hash1;

    var data2[2] = [in, 1];
    mimc2.in <== data2;
    mimc2.k <== 0;
    mimc2.out ==> hash2;

    var data3[2] = [in, 2];
    mimc3.in <== data3;
    mimc3.k <== 0;
    mimc3.out ==> hash3;

    var data4[2] = [in, 3];
    mimc4.in <== data4;
    mimc4.k <== 0;
    mimc4.out ==> hash4;

    _bits_[hash1 % 1024]++;
    _bits_[hash2 % 1024]++;
    _bits_[hash3 % 1024]++;
    _bits_[hash4 % 1024]++;

    bitsOut <-- _bits_;
}

template cbfMultiAdd(N) {
    signal input in[N];
    signal input assertBits[1024];
    var bits[1024];

    component add[N];

    for (var i = 0; i < N; i++) {
        add[i] = cbfAdd();
        add[i].in <== in[i];
        add[i].bitsIn <== bits;
        bits = add[i].bitsOut;
    }
    assertBits === bits;
}

component main = cbfMultiAdd(100);