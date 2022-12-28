# Normalization notes.

## Phase 1 - Go from object graph to messy table(s)

This is the current object graph:

```
class Dungeon {
    var name: String
    var rooms: [Room]
    ...
}

class Room {
    var name: String
    var bounds: CGRect
    var doors: [Door]
    ...
}

class Door {
    enum Material {
        case wood
        case stone
        case mimic
    }

    var name: String
    var side1: Room
    var side2: Room
    var locked: Bool
    var damaged: Bool
    var material: Material
    ...
}
```

So, with something like Rooms

```
+----+      +----+      +----+
| r1 |--d1--| r2 |--d2--| r3 |
+----+      +----+      +----+
  |                       |
  d3                      d4
  |                       |
+----+      +----+      +----+
| r4 |--d5--| r5 |--d6--| r6 |
+----+      +----+      +----+
```

**ROOMS**
| name | bounds  | doors  |
| ---- | ------- | ------ |
| r1   | x-y,w-h | d1, d3 |
| r2   | x-y,w-h | d1, s2 |
| r3   | x-y,w-h | d2, d4 |

**DOORS**
| name | side 1 | side 2 | locked | damaged | material |
| ---- | ------ | ------ | ------ | ------- | -------- |
| d1   | r1     | r2     | false  | false   | stone    |
| d2   | r2     | r3     | false  | false   | wood     |
| d3   | r1     | r4     | true   | false   | wood     |
| d4   | r3     | r6     | false  | false   | stone    |

One thing noticed is that this initial stuff doesn't have
anything optional, so no NULLs. yay

## Phase 2

Remove NULLs (well don't have them yet), and reduce multiples in
a cell into one cell.


**ROOMS**
| name | bounds  | id |
| ---- | ------- | -- |
| r1   | x-y,w-h | 0  |
| r2   | x-y,w-h | 1  |
| r3   | x-y,w-h | 2  |

**DOORS**
| name | locked | damaged | material | id |
| ---- | ------ | ------- | -------- | -- |
| d1   | false  | false   | stone    | 0  |
| d2   | false  | false   | wood     | 1  |
| d3   | true   | false   | wood     | 2  |
| d4   | false  | false   | stone    | 3  |

**ROOMDOORS**
| door id | room id |
| 0       | 0       |
| 1       | 2       |
| 2       | 2       |
| 2       | 3       |

So let's start an implementation with this.

