# compile
circom ../multiplier2.circom --r1cs --json --wasm --sym --c
# compute witness
node ./multiplier2_js/generate_witness.js ./multiplier2_js/multiplier2.wasm input.json witness.wtns
# setup
export ENTROPY="$(head -n 4096 /dev/urandom | openssl sha1)"
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
echo $ENTROPY | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup ./multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
echo $ENTROPY | snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json
# generate proof
snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
# verify
snarkjs groth16 verify verification_key.json public.json proof.json