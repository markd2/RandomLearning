package main

import (
	"fmt"
	"strings"
	"bytes"
	"unicode/utf8"
	"testing"
)

func Runes2Bytes(rs []rune) []byte {
	n := 0
	for _, r := range rs {
		n += utf8.RuneLen(r)
	}

	n, bs := 0, make([]byte, n)
	for _, r := range rs {
		n += utf8.EncodeRune(bs[n:], r)
	}
	return bs
}

var s3 string
var x = []byte{1023: 'x'}
var y = []byte{1023: 'y'}

func fc() {
	// none of the below 4 conversions will copy the bytes of x and y
	if string(x) != string(y) {
		s3 = (" " + string(x) + string(y))[1:] // compiler optimizes this, just one copy/allocation
	}
}

func fd() {
	// only the two cnversions in the comparison will not copy the underlying
	// bytes of x and y
	
	if string(x) != string(y) {
		s3 = string(x) + string(y) // compiler does not optimize this, causing three allocations
	}
}

// https://go101.org/article/string.html contributed a TON to this understanding
func main() {
	const World = "hoover"
	var hello = "greeble"

	var hw = hello + " " + World
	hw += "!"
	fmt.Println(hw)
	
	fmt.Println(hello == "greeble") // true
	fmt.Println(hello > hw) // false

	var emoji = "🇺🇸"  // emacs kind of confusd over flag length
	fmt.Println(len(emoji)) // prints _8_

	fmt.Println(emoji[3]) // prints 186
	// emoji[4] = "x"  // errors
	
	fmt.Println(hw[3:5]) // eb
	fmt.Println(hw[:5]) // greeb
	fmt.Println(hw[3:]) // eble hoover!
	fmt.Println(hw[:]) // greeble hoover!
	// fmt.Println(hw[:-5])  // errors. BUMMER!

	// var ook = &hw // ok, unused var so commented out
	// var ack = &hw[0] // error

	fmt.Println(len(hello), len(hw),
		strings.HasPrefix(hw, hello))

	var hello2 = "gre" + "eble"
	fmt.Println(len(hello), len(hw),
		strings.HasPrefix(hw, hello2))

	const s = "Go101.org" // len(s) == 9 // thank you go101
	
	// len(s) is a constant expression, len(s[:]) is not
	var a byte = 1 << len(s) / 128
	var b byte = 1 << len(s[:]) / 128
	var c int = 1 << len(s) / 128
	var d int = 1 << len(s[:]) / 128

	fmt.Println(a, b, c, d) // 4, 0, 4, 4

	// rune / byte slices
	s2 := "Color infection is a fun game" // /me waves at go101
	bs := []byte(s2) // string -> []byte
	// fmt.Println(bs) // [71 111 49 48 49 ...
	s2 = string(bs)  // []byte -> string
	rs := []rune(s2) // string -> []rune
	s2 = string(rs) // []rune -> string
	rs = bytes.Runes(bs) // []byte -> []rune
	bs = Runes2Bytes(rs) // []rune -> []byte

	fmt.Println(rs) // [ 67 111 108 ...
	fmt.Println(bs) // [ 67 111 108 ...

	for i, b := range []byte(World) { // will not copy the underlying bytes of World
		fmt.Println(i, ":", b)
	}

	key := []byte{'k', 'e', 'y'}
	m := map[string]int{}
	// the string(key) copies the bytes
	m[string(key)] = 23
	// this doesn't copy the bytes.
	fmt.Println(m[string(key)]) 

	fmt.Println(testing.AllocsPerRun(1, fc)) // 1
	fmt.Println(testing.AllocsPerRun(1, fd)) // 3

	gp := "éक्षिaπ囧"
	for i, rn := range gp {
		fmt.Printf("%2v: 0x%x %v \n", i, rn, string(rn))
	}
	fmt.Println(len(gp))
}
