package hash

import (
	"crypto/sha256"
	"hash/fnv"
	"math/big"

	"github.com/gaozhengxin/go-iden3-crypto/constants"
	"github.com/gaozhengxin/go-iden3-crypto/mimc7"
)

var sha256Hasher = sha256.New()
var fnv32Hasher = fnv.New32()
var fnv32aHasher = fnv.New32a()
var fnv64Hasher = fnv.New64()
var fnv64aHasher = fnv.New64a()
var fnv128Hasher = fnv.New128()
var fnv128aHasher = fnv.New128a()

func SHA256(input []byte) []byte {
	sha256Hasher.Write(input)
	return sha256Hasher.Sum(nil)
}

func FNV32(input []byte) []byte {
	fnv32Hasher.Write(input)
	return fnv32Hasher.Sum(nil)
}

func FNV32a(input []byte) []byte {
	fnv32aHasher.Write(input)
	return fnv32aHasher.Sum(nil)
}

func FNV64(input []byte) []byte {
	fnv64Hasher.Write(input)
	return fnv64Hasher.Sum(nil)
}

func FNV64a(input []byte) []byte {
	fnv64aHasher.Write(input)
	return fnv64aHasher.Sum(nil)
}

func FNV128(input []byte) []byte {
	fnv128Hasher.Write(input)
	return fnv128Hasher.Sum(nil)
}

func FNV128a(input []byte) []byte {
	fnv128aHasher.Write(input)
	return fnv128aHasher.Sum(nil)
}

func MiMC7_91(input []byte) []byte {
	inputBig := make([]*big.Int, 0)

	bigInt := new(big.Int).SetBytes(input)
	bigInt = new(big.Int).Mod(bigInt, constants.Q)
	inputBig = append(inputBig, bigInt)

	hs, err := mimc7.Hash(inputBig, nil, 91)
	if err != nil {
		panic(err)
	}
	return hs.Bytes()
}

func MiMC7_5(input []byte) []byte {
	inputBig := make([]*big.Int, 0)

	bigInt := new(big.Int).SetBytes(input)
	bigInt = new(big.Int).Mod(bigInt, constants.Q)
	inputBig = append(inputBig, bigInt)

	hs, err := mimc7.Hash(inputBig, nil, 5)
	if err != nil {
		panic(err)
	}
	return hs.Bytes()
}
