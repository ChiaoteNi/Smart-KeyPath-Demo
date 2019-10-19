import UIKit

// 基本架構
struct ValidationStash<ClassType, T> {
    var condition: (T) -> Bool
    var keypath: KeyPath<ClassType, T>
}

protocol Validation: class {
    associatedtype ClassType
    associatedtype ValueType
    
    var stashes: [ValidationStash<ClassType, ValueType?>]? { set get }
}

extension Validation {
    
    func check(_ target: KeyPath<ClassType, ValueType?>,
               with condition: @escaping (ValueType?) -> Bool) -> Self {
        
        let model = ValidationStash(condition: condition, keypath: target)
        if var arr = stashes {
            arr.append(model)
            stashes = arr
        } else {
            stashes = [model]
        }
        return self
    }
    
    func validate() -> Bool {
        for stashe in stashes ?? [] {
            guard let self = self as? ClassType else { continue }
            let a = self[keyPath: stashe.keypath]
            let result = stashe.condition(a)
            
            if result == false { return result }
        }
        return true
    }
}

// 設定 UITextField 要支援 Validation 的型別
extension UITextField: Validation {
    typealias ClassType = UITextField
    typealias ValueType = String

    var stashes: [ValidationStash<ClassType, ValueType?>]? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.array) as? [ValidationStash] }
        set { objc_setAssociatedObject(self, &AssociatedKeys.array, newValue, .OBJC_ASSOCIATION_RETAIN)}
    }

    fileprivate struct AssociatedKeys {
        static var counterAddress = "counter_address"
        static var array = "array"
    }
}

// 使用情境
// (1) 注入判斷條件
let userField: UITextField = .init()
userField
    .check(\.text, with: { $0?.isEmpty == false })
    .check(\.text, with: { $0?.count ?? 0 >= 8 })
    .check(\.text, with: { $0 != "123456789" })

let pswdField: UITextField = .init()
pswdField
    .check(\.text, with: { $0?.isEmpty == false })
    .check(\.text, with: { $0?.count ?? 0 >= 6 })
    .check(\.text, with: { $0 != "123456" })

// (2) user輸入內容
userField.text = "123456dddddd"
pswdField.text = "123456"

// (3) Submit時做條件判斷
userField.validate() // false
pswdField.validate() // true
