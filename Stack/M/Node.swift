import SwiftUI; import Combine

struct Dependency {
    var nodes: [Node]
    var computation: ([Double]) -> Double
}

struct ChangesDuringAppSession {
    var manual = 0, viaAPI = 0, viaFormula = 0
}

class Node: ObservableObject, Identifiable, Equatable, Hashable {
    let index: Int
    var value: Double {
        didSet {
            if oldValue != value {
                //print("[didSet] value change: node \(nodeLabel) changed from \(oldValue) to \(value)\n")
            } else {
                //print("[didSet] value of node \(nodeLabel) unchanged")
            }
            valueChanged.send(value) // send new value thru publisher when value changes
        }
    }
    
    let valueChanged = PassthroughSubject<Double, Never>() // publisher for value changes
    var subscriptions = Set<AnyCancellable>() // storage for subscriptions
    
    var dependency: Dependency?
    var dependents = [Node]()
    var visited = false
    var inRecStack = false
    
    var isSetFromRestAPI = false
    var viewModelRows = 0
    var changes = ChangesDuringAppSession()
    var displayValue: String { String(format: "%.2f", value) }
    var nodeLabel: String { "\(self.index)\(columnAndRow(from: self.index))" }
    
    init(index: Int, value: Double) {
        self.index = index
        self.value = value
    }
    deinit {
        subscriptions.removeAll()
    }
    
    func columnAndRow(from index: Int) -> (Int,Int) {
        (index / viewModelRows, index % viewModelRows)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.index == rhs.index && lhs.value == rhs.value
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(value)
    }
}
