import UIKit

@dynamicMemberLookup
struct Lens<Root: AnyObject> {
    
    var value: Root
    
    // (1) 取屬性
    subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value?>) -> Value? {
            print("return value!")
            return value[keyPath: keyPath]
    }
    
    //// (2) 取Array
    //    subscript<Value>(
    //        dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value?>) -> [Value?] {
    //            print("return array!")
    //            let item = value[keyPath: keyPath]
    //            let array = [item, item]
    //            return array
    //    }
    //
    ////// (3) 取closure
    ////    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value>)
    ////        -> (_ value: Value) -> Lens<Root> {
    ////            print("return closure!")
    ////            let closure: (_ value: Value) -> Lens<Root>
    ////                = { value in
    ////                    self.value[keyPath: keyPath] = value
    ////                    return self
    ////            }
    ////            return closure
    ////    }
}

let label = UILabel()
label.text = "HIHI"
var lens = Lens(value: label)
lens.text // (1) 取屬性
//lens.text[0] // (2) 取以屬性命名的Array
////lens.text("yaya") // (3) 取以屬性命名的closure

// 但將對直接取KeyPath效能較差，請見 KeyPath_Fluent Builder
