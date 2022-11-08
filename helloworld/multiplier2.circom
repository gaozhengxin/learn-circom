pragma circom 2.0.0;

template Multiplier2() {
    signal input a;
    signal input b;
    signal output c;
    //c <== a*a + b; // 可以
    //c <== a + b; // 不行
    c <== a*b;
 }

 component main = Multiplier2();