# setup powers of tau
echo "setup powers of tau"
# export ENTROPY="$(head -n 4096 /dev/urandom | openssl sha1)"
export ENTROPY="123123123"
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
echo $ENTROPY | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
# compile
echo "compile"
circom ../mimc.circom --r1cs --json --wasm --sym --c
# compute witness
echo "compute witness"
node ./mimc_js/generate_witness.js ./mimc_js/mimc.wasm input.json witness.wtns
# setup groth16
echo "setup groth16"
# export ENTROPY="3ca2195b3097a754ef58e7eeef40a9c4acc33cad"
snarkjs groth16 setup ./mimc.r1cs pot12_final.ptau mimc_0000.zkey
echo $ENTROPY | snarkjs zkey contribute mimc_0000.zkey mimc_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey mimc_0001.zkey verification_key.json
# generate proof
echo "generate proof"
snarkjs groth16 prove mimc_0001.zkey witness.wtns proof.json public.json
# verify
snarkjs groth16 verify verification_key.json public.json proof.json