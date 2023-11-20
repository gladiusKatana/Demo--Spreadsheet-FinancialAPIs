extension GridViewModel {
    
    func computeNodeAndSetSubscriptions(forNode node: Node, inputs: [Node], computation: @escaping ([Double]) -> Double) {
        let prynt = false
        let nodeColRow = "\(self.columnAndRow(from: node.index))"
        var changesDetected = 0, changesRequired = 1
        recomputeNode()
        
        for (index, input) in inputs.enumerated() {
            /// subscribe node to changes in its dependencies
            input.valueChanged.sink { _ in
                let depNodeColRow = "\(self.columnAndRow(from: input.index))" ///; print("node \(depNodeColRow) changed to \(dependencyNode.value)")
                
                var otherInputs = inputs
                otherInputs.remove(at: index)
                let chainedDependencies = Set(otherInputs).intersection(Set(input.dependents))
                let chainedDepCount = chainedDependencies.count
                
                changesRequired += chainedDepCount
                changesDetected += 1
                
                if changesDetected == changesRequired {
                    if prynt { print("node \(nodeColRow) got \(changesDetected) of \(changesRequired) changes after node \(depNodeColRow) changed; recomputing...") }
                    recomputeNode()
                    node.changes.viaFormula += 1
                    changesDetected = 0; changesRequired = 1
                } else {
                    if prynt {
                        print("node \(nodeColRow) got \(changesDetected) of \(changesRequired) changes after node \(depNodeColRow) changed BUT \(chainedDepCount) more changes expected [to nodes \(chainedDependencies.map{self.columnAndRow(from: $0.index)})]")
                    }
                }
            }
            .store(in: &node.subscriptions) /// store subscription so it can be canceled when needed
        }
        
        func recomputeNode() { /// this should only be called twice - once on initial setup of formulas; then again on receiving subscribed changes
            let values = inputs.map{$0.value}
            node.value = computation(values)
        }
        
    }
    
}
