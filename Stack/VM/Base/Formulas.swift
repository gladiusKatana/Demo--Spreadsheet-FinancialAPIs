extension GridViewModel {
    func setFormulaForNode(_ column: Int, _ row: Int, /// or could make these external names 'withColumn' and 'andRow'
                           inputs: [(Int,Int)],
                           function: String = #function, line: Int = #line, file: String = #file,
                           computation: @escaping (SafeArray<Double>) -> Double) {
        /// guard against invalid node
        guard let node = n(column, row, function, line, file) else { return }
        
        guard inputs.count > 0 else {
            logFormulaError(message: "⚠️no parameters passed into formula", reminder: "simply set the node's .value instead", function, line, file)
            return
        }
        
        var inputNodes = [Node]()
        for input in inputs {
            /// guard against invalid input-nodes
            guard let inputNode = n(input.0, input.1, function, line, file) else {
                return
            }
            
            /// guard against self-references
            guard input != (column,row) else {
                logFormulaError(message: "⚠️self-reference at [\(column),\(row)]", reminder: "a cell cannot reference itself", function, line, file)
                return
            }
            
            /// guard against circular references
            let dep = inputNode.dependency
            guard dep == nil || !dep!.nodes.contains(where: { $0.index == node.index }) else {
                logFormulaError(message: "⚠️circular reference at [\(column),\(row)]", reminder: "a cell cannot reference another cell that is already referencing it", function, line, file)
                return
            }
            
            inputNodes.append(inputNode)
        }
        
        let safeComputation: ([Double]) -> Double = { values in
            let safeValues = SafeArray(values) /// SafeArray returns a default value for any invalid array indices passed into the 'computation' closure
            return computation(safeValues)
        }
        
        node.dependency = Dependency(nodes: inputNodes, computation: safeComputation)
        
        /// guard against cycles in the dependency graph
        for node in nodes {
            node.resetVisitFlags()
        }
        guard !node.hasCycle() else {
            node.dependency = nil
            logFormulaError(message: "⚠️formula for [\(column),\(row)] causes a cycle", reminder: "(while this attempted formula, if created, would have closed a cycle in the dependency graph and thus will be aborted, checking all other formulas in this view model is recommended)", function, line, file)
            return
        }
        
        /// set dependents for each node, so dependents can react to subscribed changes without redundant or early updates
        for inp in inputNodes {
            if !inp.dependents.contains(node) {
                inp.dependents.append(node)
            }
        }
        
        computeNodeAndSetSubscriptions(forNode: node, inputs: inputNodes, computation: safeComputation)
    }
    
}
