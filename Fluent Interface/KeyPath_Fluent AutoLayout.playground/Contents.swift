import UIKit

// AutoLayout
extension UIView {
    
    // MARK: - NSLayoutAnchor
    @discardableResult
    func anchor<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation = .equal,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        multiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required) -> Self {
        
        constraint(keyPath, relation, to: anchor, constant: constant, multiplier: multiplier, priority: priority)
        return self
    }
    
    @discardableResult
    func constraint
        <LayoutType: NSLayoutAnchor<AnchorType>, AnchorType>
        (_ keyPath: KeyPath<UIView, LayoutType>,
         _ relation: NSLayoutConstraint.Relation = .equal,
         to anchor: LayoutType,
         constant: CGFloat = 0,
         multiplier: CGFloat? = nil,
         priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        if let multiplier = multiplier,
            let dimension = self[keyPath: keyPath] as? NSLayoutDimension,
            let anchor = anchor as? NSLayoutDimension {
            
            switch relation {
            case .equal:
                constraint = dimension.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = dimension.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = dimension.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            }
        } else {
            switch relation {
            case .equal:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        
        return constraint
    }
    
    // MARK: - NSLayoutDimension
    @discardableResult
    func anchor(_ anchor: KeyPath<UIView, NSLayoutDimension>,
                _ relation: NSLayoutConstraint.Relation = .equal,
                to constant: CGFloat) -> Self {
        
        constraint(anchor, relation, to: constant)
        return self
    }
    
    @discardableResult
    func constraint(_ keyPath: KeyPath<UIView, NSLayoutDimension>,
                    _ relation: NSLayoutConstraint.Relation = .equal,
                    to constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = self[keyPath: keyPath].constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            constraint = self[keyPath: keyPath].constraint(lessThanOrEqualToConstant: constant)
        }
        
        constraint.isActive = true
        return constraint
    }
}

let view = UIView()
let nameLabel = UILabel()
let descLabel = UILabel()
view.addSubview(nameLabel)
view.addSubview(descLabel)

let topConstraint = nameLabel.constraint(\.leadingAnchor, to: view.leadingAnchor)
topConstraint.constant = 10

nameLabel
    .anchor(\.topAnchor, to: view.topAnchor)
    .anchor(\.bottomAnchor, to: view.bottomAnchor)
    .anchor(\.widthAnchor, to: 50)
    .anchor(\.widthAnchor, .greaterThanOrEqual, to: 50)
    .anchor(\.leadingAnchor, .equal, to: view.leadingAnchor, constant: 50)
descLabel
    .anchor(\.widthAnchor, .equal, to: view.widthAnchor, multiplier: 0.2)
    .anchor(\.heightAnchor, .greaterThanOrEqual, to: view.heightAnchor)
    .anchor(\.centerXAnchor, .equal, to: view.centerXAnchor)
    .anchor(\.centerYAnchor, .equal, to: view.centerYAnchor)

nameLabel.translatesAutoresizingMaskIntoConstraints = false
nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2, constant: 10).isActive = true
nameLabel.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

descLabel.translatesAutoresizingMaskIntoConstraints = false
descLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 10).isActive = true
descLabel.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor).isActive = true
descLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

descLabel.translatesAutoresizingMaskIntoConstraints = false
let constraints = [
    descLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 10),
    descLabel.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor),
    descLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
    descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
]
NSLayoutConstraint.activate(constraints)







