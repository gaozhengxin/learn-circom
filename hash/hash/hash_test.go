package hash

import (
	"math/rand"
	"testing"
)

func init() {
	rand.Seed(1111)
}

var letterBytes = []byte("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func RandStringBytes(n int) []byte {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return b
}

func BenchmarkSHA256(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := SHA256(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV32(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV32(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV32a(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV32a(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV64(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV64(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV64a(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV64a(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV128(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV128(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkFNV128a(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := FNV128a(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkMiMC7_91(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := MiMC7_91(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}

func BenchmarkMiMC7_5_64(b *testing.B) {
	for n := 0; n < b.N; n++ {
		hs := MiMC7_5(RandStringBytes(64))
		b.Logf("%x\n", hs)
	}
}
