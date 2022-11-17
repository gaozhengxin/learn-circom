package main

import (
	"encoding/json"
	"fmt"

	"github.com/iden3/go-iden3-crypto/poseidon"
)

func main() {
	var input string = "abcd"
	inputNum := make([]int, len([]byte(input)))
	for i, b := range []byte(input) {
		inputNum[i] = int(b)
	}

	hash, err := poseidon.HashBytes([]byte(input))
	if err != nil {
		fmt.Println(err)
	}
	hashNum := make([]int, len(hash.Bytes()))
	for i, b := range hash.Bytes() {
		hashNum[i] = int(b)
	}

	args := struct {
		In         []int `json:"in"`
		Commitment []int `json:"commitment"`
	}{
		In:         inputNum,
		Commitment: hashNum,
	}
	argsJSON, err := json.Marshal(args)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(argsJSON))
}
