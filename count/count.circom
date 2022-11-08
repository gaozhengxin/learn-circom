pragma circom 2.0.0;

template Count(N) {
    signal input k;
    signal input in[N][20];
    signal output out[20];
    var count[20];
    for (var j = 0; j < 20; j++){
        var count = 0;
        for(var i = 0; i < N; i++){
            count += in[i][j];
        }
        out[j] <== k*count;
    }
}

//component main = Count(64);
component main = Count(1024);