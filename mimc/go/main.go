package main

import (
	"encoding/json"
	"fmt"
	"math/big"

	"github.com/iden3/go-iden3-crypto/mimc7"
)

func main() {
	input := make([]*big.Int, 0)
	input = append(input, big.NewInt(1000))

	hash, _ := mimc7.Hash(input, nil)

	args := struct {
		In         []*big.Int `json:"in"`
		Commitment string     `json:"commitment"`
	}{
		In:         input,
		Commitment: hash.String(),
	}
	argsJSON, err := json.Marshal(args)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(argsJSON))
}