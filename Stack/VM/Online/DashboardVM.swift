class DashboardViewModel: BitcoinAndFiatAPIViewModel {
    override init(cols: Int, rows: Int) {
        super.init(cols: cols, rows: rows)
        setFormulaForNode(0,2,
                          inputs: [(0,0), (0,5)]) { n in
            n[0] * n[1]
        }
        setFormulaForNode(0,7,
                          inputs: [(0,5)]) { n in
            return 1 / n[0] //  / n[1]  // <-- try uncommenting the "/ n[1]" - notice it fails safely
        }
        
        //temporary formula assignments for quick test of guard against cycles in dependency graph
        n(2,0)?.value = 1
        setFormulaForNode(2,1,
                          inputs: [(2,0)]) { n in
            return n[0] * 2
        }
        setFormulaForNode(2,2,
                          inputs: [(2,1)]) { n in
            return n[0] * 2
        }
        setFormulaForNode(2,0,
                          inputs: [(2,2)]) { n in
            return n[0] * 2
        }
        
    }
    
}
