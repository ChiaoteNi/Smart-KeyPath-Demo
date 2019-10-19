import UIKit

/// ============================
// (1) 單純 KeyPath 實作版 (Swift 4可用)
/// ============================
protocol FluentBuilder { }

extension FluentBuilder where Self: AnyObject {
    
    @discardableResult
    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}
extension NSObject: FluentBuilder { }

// KeyPath 實作版 使用範例
var fluentLabel = UILabel()
    .set(\UILabel.text, to: "Hello World.")
    .set(\UILabel.font, to: .systemFont(ofSize: 14))
    .set(\UILabel.lineBreakMode, to: .byWordWrapping)
    .set(\UILabel.numberOfLines, to: 0)
    .set(\UILabel.textColor, to: .darkGray)

/// ============================
// (2) dynamicMemberLookup 實作版 (Swift 5.1)
/// ============================
// https://github.com/marty-suzuki/DuctTape <- 順帶介紹某個github上某個以同樣方式實作的lib
@dynamicMemberLookup
struct Builder<Root: NSObject> {

    var target: Root

    init(with object: Root = Root()) {
        target = object
    }

    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value>)
        -> (_ value: Value)->Builder<Root> {

            return { value in
                self.target[keyPath: keyPath] = value
                return self
            }
    }

    func build() -> Root {
        return target
    }
}

protocol Buildable {}
extension Buildable where Self: NSObject {
    static var Builder: Builder<Self> {
        return .init()
    }
}
extension NSObject: Buildable {}

// dynamicMemberLookup 實作版 使用範例
let userNameLabel = UILabel.Builder
    .text("")
    .font(.systemFont(ofSize: 14))
    .textColor(.red)
    .backgroundColor(.black)
    .build()


/// ============================
// 簡易效能比較
/// ============================
let loopTimes = 10000 // 重複設值10000次

//// 一般設值
let label = UILabel()
let start = Date()
for i in 0 ... loopTimes {
    label.text = "\(i)"
}
let interval = Date().timeIntervalSince(start)
print(interval) // 0.60秒

// dynamicMemberLookup 設值
let buildStart = Date()
let builder = UILabel.Builder
for i in 0 ... loopTimes {
    builder.text("\(i)")
}
let buildLabel = builder.build()
let buildInterval = Date().timeIntervalSince(buildStart)
print(buildInterval) // 2.15秒 <- 時間較長

// keyPath 設值
let keyPathLabel = UILabel()
let keyPathBuildStart = Date()
for i in 0 ... loopTimes {
    keyPathLabel.set(\.text, to: "\(i)")
}
let keyPathBuildInterval = Date().timeIntervalSince(keyPathBuildStart)
print(keyPathBuildInterval) // 1.33秒 <- 較dynamicMemberLookup快
