package main

import (
	"encoding/json"
	"fmt"
	"math/big"

	"github.com/iden3/go-iden3-crypto/mimc7"
)

func main() {
	input := make([]*big.Int, 0)
	//input = append(input, big.NewInt(1000))
	//input = append(input, big.NewInt(2000))
	input = append(input, big.NewInt(12))

	hash, _ := mimc7.Hash(input, nil)

	args := struct {
		In   []*big.Int `json:"in"`
		Hash string     `json:"hash"`
	}{
		In:   input,
		Hash: hash.String(),
	}
	argsJSON, err := json.Marshal(args)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(argsJSON))
}
