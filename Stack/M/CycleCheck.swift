extension Node {
    
    func hasCycle() -> Bool {
        if inRecStack { // node is in recursion stack, cycle detected
            return true
        }
        
        if visited { // node has been visited and no cycle was found previously
            return false
        }
        
        // mark the node as visited and part of recursion stack
        visited = true
        inRecStack = true
        
        if let dependencies = dependency?.nodes {
            for depNode in dependencies {
                if depNode.hasCycle() {
                    return true // cycle detected in one of the dependencies
                }
            }
        }
        
        inRecStack = false // current path didn't lead to a cycle, remove node from recursion stack
        return false
    }
    
    // call this before starting the cycle detection
    func resetVisitFlags() {
        visited = false
        inRecStack = false
    }
    
}
