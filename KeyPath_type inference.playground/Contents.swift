import UIKit

// KeyPath 基本操作 & 型別推斷示範
class DemoObject {
    var index: Int = 0
    var name: String = "Test1"
    var subObj: SubObject!
    var optionalSubObj: SubObject?
}

class SubObject {
    var subIndex: Int = 0
}

struct DemoStruct {
    var id: Int
    var name: String { return "Aaron" }
}

// 型別推斷示範
let namePath = \DemoObject.name                                     // ReferenceWritableKeyPath<DemoObject, String>
let idPath = \DemoStruct.id                                         // WritableKeyPath<DemoStruct, Int>
let getOnlyIDPath: KeyPath<DemoStruct, Int> = \DemoStruct.id        // KeyPath<DemoStruct, Int>
let computedPropPath = \DemoStruct.name                             // KeyPath<DemoStruct, String>
let optionalPath = \DemoObject.subObj?.subIndex                     // KeyPath<DemoObject, Int?>  <-- get only

var object: DemoStruct = .init(id: 0)
//object[keyPath: firstPath]            // <= Type safe, IDE是能幫你做型別判斷的 (把這行解除mark便可正確得到錯誤

// 基本操作示範
var obj: DemoObject = .init()
obj.subObj = .init()

let indexPath = \DemoObject.index
let subObjPath = \DemoObject.subObj
let subIndexPath = \DemoObject.subObj.subIndex

var index = obj[keyPath: indexPath]
var name = obj[keyPath: namePath]
var subObj = obj[keyPath: subObjPath]
var subIndex = obj[keyPath: subIndexPath]

print(index, name, subObj, subIndex)

obj.index = 2
obj.name = "Name Changed"
obj.subObj?.subIndex = 3

print(index, name, subIndex)
print(obj[keyPath: indexPath], obj[keyPath: namePath], obj[keyPath: subIndexPath])

obj[keyPath: indexPath] = 3
obj[keyPath: namePath] = "HaHaHa"
obj[keyPath: subIndexPath] = 4

print(index, name, subIndex)
print(obj[keyPath: indexPath], obj[keyPath: namePath], obj[keyPath: subIndexPath])
