#!/usr/bin/swift

// https://leetcode.com/problems/reorder-routes-to-make-all-paths-lead-to-the-city-zero/
// Beats 91.11% of runtime, 64.44% of memory

// Approach - make a list of connections between cities, with an outgoing flag
// so, for connection [0, 4], city zero will have a "4, outgoing is true", and
// city 4 will have a "0, outgoing is false"
// walk the connections
//  - if we've seen a city, bailout. Don't double-process
//  - otherwise count the number of outgoing connections, and flip them
//    (doesn't actually flip, just counts)

struct Connection {
    let cityNumber: Int
    let outgoing: Bool
}

struct City {
    var visited = false
    var connections: [Connection] = []
}

var cities: [City] = []

func minReorder(_ n: Int, _ connections: [[Int]]) -> Int {
    cities = Array(repeating: City(), count: n)
    for connection in connections {
        let from = connection[0]
        let to = connection[1]
        cities[from].connections.append(Connection(cityNumber: to, outgoing: true))
        cities[to].connections.append(Connection(cityNumber: from, outgoing: false))
    }

    var flippa = 0

    func flipAndWalk(city: Int) {
        cities[city].visited = true

        for connection in cities[city].connections {
            let destination = connection.cityNumber
            if cities[destination].visited { continue }

            if connection.outgoing {
                flippa += 1
            }

            flipAndWalk(city: destination)
        }
    }

    flipAndWalk(city: 0)

    return flippa
}

let n1 = 6
let rawConnections1 = [[0,1],[1,3],[2,3],[4,0],[4,5]]
let expected1 = 3

if minReorder(n1, rawConnections1) != expected1 {
    print("bummer 1")
}


let n2 = 5
let rawConnections2 = [[1,0],[1,2],[3,2],[3,4]]
let expected2 = 2

if minReorder(n2, rawConnections2) != expected2 {
    print("bummer 2")
}

let n3 = 3
let rawConnections3 = [[1,0], [2,0]]
let expected3 = 0

if minReorder(n3, rawConnections3) != expected3 {
    print("bummer 3")
}
