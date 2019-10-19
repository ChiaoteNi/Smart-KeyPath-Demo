import UIKit

extension Sequence {
    func sorted<T: Comparable>(_ keyPath: KeyPath<Element, T>,
                               by comparation: (T, T) -> Bool) -> [Element] {

        return sorted(by: { comparation($0[keyPath: keyPath],
                                        $1[keyPath: keyPath])
        })
    }

    func sum<T: Numeric>(for keyPath: KeyPath<Element, T>) -> T {
        return reduce(into: 0, {$0 += $1[keyPath: keyPath]})
    }

    func max<T: Comparable>(of keyPath: KeyPath<Element, T>) -> Element? {
        return self.max(by: { $0[keyPath: keyPath] > $1[keyPath: keyPath] })
    }

    func min<T: Comparable>(of keyPath: KeyPath<Element, T>) -> Element? {
        return self.min(by: { $0[keyPath: keyPath] > $1[keyPath: keyPath] })
    }

    func filter<T: Comparable>(of keyPath: KeyPath<Element, T>,
                               between range: Range<T>) -> [Element] {

        return filter({ range.contains($0[keyPath: keyPath]) })
    }
}

extension Array {
    func calculate<T: Comparable>(_ keyPath: KeyPath<Element, T>,
                                  with operation: (T, T) -> T) -> T? {
        
        guard !isEmpty else { return nil }
        var copy = self
        let initValue = copy.removeFirst()[keyPath: keyPath]
        
        return copy.reduce(initValue, {
            operation($0, $1[keyPath: keyPath])
        })
    }
    
    func average<T: BinaryFloatingPoint>(for keyPath: KeyPath<Element, T>) -> T {
        return T(Double(sum(for: keyPath)) / Double(count))
    }
    
    func average(for keyPath: KeyPath<Element, Int>) -> Double {
        return Double(sum(for: keyPath)) / Double(count)
    }
}

struct Object {
    var value: Int
}

// 範例1
var arr = [Int]
    .init(0...5)
    .compactMap({ Object(value: $0)})

arr.sort(by: { $0.value > $1.value })
// |
// v
arr.sorted(\.value, by: >)

// 範例2
struct Ticket {
    var price: Int
}

let tickets = [Int](0...5)
    .compactMap{ Ticket(price: $0) }

tickets.sum(for: \.price)                   // 15
tickets.calculate(\.price, with: +)         // 15
tickets.sorted(\.price, by: >)              // {price 5}, ..., {price 1}
tickets.filter(of: \.price, between: 2 ..< 4) // price = 2, 3 的 Ticket
tickets.max(of: \.price)?.price             // 5
tickets.min(of: \.price)?.price             // 0
tickets.average(for: \.price)               // 2.5
