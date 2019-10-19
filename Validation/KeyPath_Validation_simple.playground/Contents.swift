import UIKit

// 基本架構
protocol Validation: NSObject { }

extension Validation {
    
    var currentResult: Bool? {
        get { return objc_getAssociatedObject(self,
              &AssociaKeys.currResult) as? Bool }
        set { objc_setAssociatedObject(self,
              &AssociaKeys.currResult, newValue,
              .OBJC_ASSOCIATION_RETAIN)}
    }
    
    func check<T>(_ target: KeyPath<Self, T>, with condition:
        (T) -> Bool) -> Self {
        if currentResult == false {
            return self
        } else {
            self.currentResult
                = condition(self[keyPath: target])
            return self
        }
    }
    
    func validate() -> Bool {
        if let validate = currentResult {
            currentResult = nil
            print(validate)
            return validate
        } else {
            return true
        }
    }
}

extension NSObject: Validation {
    fileprivate struct AssociaKeys {
        static var currResult = "currResult"
    }
}

// 使用方式
let pswdField: UITextField = .init()
pswdField
    .check(\.text, with: { $0?.isEmpty == false })
    .check(\.text, with: { $0?.count ?? 0 >= 6 })
    .check(\.text, with: { $0 != "123456" })
    .check(\.frame.size.width, with: { $0 >= 100 })
    .validate()

let image: UIImage = .init()
image
    .check(\.size.width, with: { $0 > 300 })
    .check(\.size.height, with: { $0 > 600 })
    .validate()

let scrollView: UIScrollView = .init()
scrollView
    .check(\.contentSize, with: { $0.height > 500 })
    .check(\.contentOffset, with: { $0.y <= 300 })
    .validate()
