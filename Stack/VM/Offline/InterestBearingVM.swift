class InterestBearingAccountViewModel: GridViewModel {
    override init(cols: Int, rows: Int) {
        super.init(cols: cols, rows: rows)
        
        n(0,0)?.value = 400    /// simulated account current balance (eg. line of credit) - should be user-input
        n(2,0)?.value = -10    /// simulated initial monthly minimum payment - should be user-input
        let r = 0.12 / 12      /// simulated monthly interest rate - should be user-input or fetched infrequently via API
        
        for i in 0...rows - 1 {
            // interest amount expected by the end of the current month
            setFormulaForNode(1,i,
                              inputs: [(0,i)]) { n in
                n[0] * r
            }
            if i > 0 {
                // balance at the start of the current month
                setFormulaForNode(0,i,
                                  inputs: [(0,i-1), (1,i-1), (2,i-1)]) { n in
                    n[0] + n[1] + n[2] /// add previous month's (balance + interest + payment)
                }
                // monthly minimum payments - equal to previous month's value by default
                setFormulaForNode(2,i,
                                  inputs: [(2,i-1)]) { n in
                    n[0]
                }
            }
            // additional payment for the month - should be user-input
            n(3,i)?.value = 0
        }
    }
    
}
