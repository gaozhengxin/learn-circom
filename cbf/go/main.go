package main

import (
	"encoding/json"
	"fmt"
	"math/big"
	"math/rand"

	"github.com/gaozhengxin/cbf"
)

func init() {
	rand.Seed(111111)
}

var letterBytes = []byte("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func RandStringBytes(n int) []byte {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return b
}

func main_1() {
	data := RandStringBytes(64)
	input := cbf.EncodeData(data)
	index := new(big.Int).Mod(input, big.NewInt(64))
	args := struct {
		In          string `json:"in"`
		AssertIndex string `json:"assertIndex"`
	}{
		In:          input.String(),
		AssertIndex: index.String(),
	}
	argsJSON, err := json.Marshal(args)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(argsJSON))
}

func main() {
	filter := cbf.NewCBF(uint(1024), uint(4))

	inputs := make([]*big.Int, 0)
	for {
		data := RandStringBytes(64)
		// inputs = append(inputs, data)
		inputs = append(inputs, cbf.EncodeData(data)) // 多做一次 mod，结果是一样的，但电路 input 需要经过 mod
		filter.TestAndAdd(data)
		if filter.Count() < 100 {
			continue
		}
		break
	}

	inputsStr := make([]string, len(inputs))
	for i, n := range inputs {
		inputsStr[i] = n.String()
	}

	data := filter.Data()
	assertBits := make([]int, len(data))
	for i := 0; i < len(data); i++ {
		assertBits[i] = int(data[i])
	}
	args := struct {
		In         []string `json:"in"`
		AssertBits []int    `json:"assertBits"`
	}{
		In:         inputsStr,
		AssertBits: assertBits,
	}
	argsJSON, err := json.Marshal(args)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(argsJSON))
}
