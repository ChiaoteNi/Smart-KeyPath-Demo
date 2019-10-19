import UIKit

// KeyPath append
class TopLevelObject {
    var subObj: SecondLevelObject = .init()
    var name: String = ""
    var value: Int = 0
}

class SecondLevelObject {
    var subObj: ThirdLevelObject = .init()
    var name: String = ""
    var value: Int = 0
}

class ThirdLevelObject {
    var name: String = ""
    var value: Int = 0
}

let topLevel: TopLevelObject = .init()
topLevel.name = "I'm the top."
topLevel.value = 3

let secondLevel = topLevel.subObj
secondLevel.name = "HaHa"
secondLevel.value = 2

let thirdLevel = secondLevel.subObj
thirdLevel.name = "I'm the last one."
thirdLevel.value = 1

let root = \TopLevelObject.subObj
let secKeyPath = \SecondLevelObject.subObj
let thirdKeyPath = \ThirdLevelObject.name

print(topLevel[keyPath: root])

var finalKetPath = root
    .appending(path: secKeyPath)
    .appending(path: thirdKeyPath)

print(topLevel[keyPath: finalKetPath])
