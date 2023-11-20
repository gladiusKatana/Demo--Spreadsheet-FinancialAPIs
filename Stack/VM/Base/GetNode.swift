extension GridViewModel {
    
    /// shorthand signature to call getNode(...), with debug log parameters (function line, file) to identify invalid cell references
    func n(_ column: Int, _ row: Int,
           _ function: String = #function, _ line: Int = #line, _ file: String = #file) -> Node? {
        return getNode(atColumn:column, andRow:row, function, line, file)
    }
    
    
    func getNode(atColumn column: Int, andRow row: Int,
                 _ function: String = #function, _ line: Int = #line, _ file: String = #file) -> Node? {
        
        guard column >= 0, column < cols,
              row >= 0, row < rows else {
            logFormulaError(message: "⚠️invalid node reference at [\(column),\(row)]", reminder: rowColumnWarning, function, line, file)
            return nil
        }
        
        let index = index(from: column,row)
        guard index >= 0, index < nodes.count else { /// this condition should always be met - colum & row are below max
            logFormulaError(message: "❗️you somehow got an out-of-bounds error from an invalid index, .nodes[\(index)]", reminder: nodeCountWarning, function, line, file)
            return nil
        }
        return nodes[index]
    }
    
}
