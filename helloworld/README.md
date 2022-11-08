https://docs.circom.io/getting-started/

### 编译
```
$ circom multiplier2.circom --r1cs --json --wasm --sym --c
```
生成
r1cs 和 json 格式的约束方程组
sym 符号文件
js 电路和 cpp 电路

### 生成 witness
```
$ node generate_witness.js multiplier2.wasm input.json witness.wtns
```
生成 `witness.wtns`
也可以用 C++
```
$ make
$ ./multiplier2 input.json witness.wtns
```

### setup

#### Powers of Tau (通用的)
```
$ snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
$ snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
```
先生成 `pot12_0000.ptau`  
再生成 `pot12_0001.ptau`

#### Phase 2 生成 proving key 和 verification key（与电路有关的）
```
$ snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
$ snarkjs groth16 setup ../multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
$ snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
$ snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json
```
生成 `pot12_final.ptau`  
然后生成 `multiplier2_0000.zkey`  
然后生成 `multiplier2_0001.zkey`  
然后生成 `verification_key.json`

### 证明
```
$ snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
得到 proof.json 和 pulic.json (可公开的输入和输出)
```

### 验证
```
$ snarkjs groth16 verify verification_key.json public.json proof.json
```

### 生成验证合约
```
$ snarkjs zkey export solidityverifier multiplier2_0001.zkey verifier.sol
```