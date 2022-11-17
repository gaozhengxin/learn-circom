# setup powers of tau
echo "setup powers of tau"
export ENTROPY="$(head -n 4096 /dev/urandom | openssl sha1)"
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
echo $ENTROPY | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
# compile
echo "compile"
circom ../count.circom --r1cs --json --wasm --sym --c
# compute witness
echo "compute witness"
#node ./count_js/generate_witness.js ./count_js/count.wasm input-64.json witness.wtns
node ./count_js/generate_witness.js ./count_js/count.wasm input-1024.json witness.wtns
# setup groth16
echo "setup groth16"
snarkjs groth16 setup ./count.r1cs pot12_final.ptau count_0000.zkey
echo $ENTROPY | snarkjs zkey contribute count_0000.zkey count_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey count_0001.zkey verification_key.json
# generate proof
echo "generate proof"
snarkjs groth16 prove count_0001.zkey witness.wtns proof.json public.json
# verify
echo "verify"
snarkjs groth16 verify verification_key.json public.json proof.json