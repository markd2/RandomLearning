
// swiftc -O test-opt.swift -o to
// swiftc    test-opt.swift -o tg

let n = 10000
var x = [Int](repeating: 1, count: n)

for i in 0 ..< n {
    for j in 0 ..< n {
        x[i] ^= x[j] << (i+j) % 16
    }
}

print("blah: \(x[0])")
