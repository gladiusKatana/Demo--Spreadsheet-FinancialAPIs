import SwiftUI; import Combine


class GridViewModel: ObservableObject, GridViewModelProtocol {
    var cols: Int = 0, rows: Int = 0
    var nodes = [Node]()
    @Published var selectedNode: Node?
    
    var className: String { String(describing: type(of: self)) }
    var nodeCountWarning: String { "min. index: 0; max. index: \(nodes.count-1)" }
    var rowColumnWarning: String { "columns go from 0 to \(cols-1); rows, from 0 to \(rows-1)" }
    
    init(cols: Int, rows: Int) {
        self.cols = cols; self.rows = rows
        self.nodes = (0..<cols * rows).map {
            let node = Node(index: $0, value: 0.0)
            node.viewModelRows = rows
            return node
        }
    }
    
    func index(from column: Int, _ row: Int) -> Int {
        column * rows + row
    }
    
    func columnAndRow(from index: Int) -> (Int,Int) {
        (index / rows, index % rows)
    }
    
    
    func logFormulaError(message: String, reminder gridMsg: String = "",
                         _ function: String = #function, _ line: Int = #line, _ file: String = #file) {
        print(message + ",\non line \(line) in \(String(describing: className)).\(function)" + "\n" + gridMsg)
        print("↳ aborting formula assignment\n")
    }
    
    deinit {
        for node in nodes {
            node.subscriptions.removeAll()
        }
    }
}
