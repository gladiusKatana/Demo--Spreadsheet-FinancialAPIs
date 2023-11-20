import SwiftUI

class BitcoinAndFiatAPIViewModel: BitcoinAPIViewModel {
    var fiatTimer: Timer?
    @Published var fiatExchangeRate: Double = 0
    
    override func updateFinancialData() {
        getBitcoinPriceWithTimer()
        getFiatPriceWithTimer()
    }
    
    func getFiatPriceWithTimer() {
        self.getFiatExchangeRate()
        fiatTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.getFiatExchangeRate()
        }
    }
    
    private func getFiatExchangeRate() { // helper func.
        updateValue(
            using: networkManager.fetchExchangeRate,
            onSuccess: { rate in
                self.setNodeAndPropertyFromApi(with: rate, for: &self.fiatExchangeRate,
                                               atColumn: 0, andRow: 5)
            },
            onFail: { self.fiatExchangeRate = 1.0 } /// default value
        )
    }
    
    deinit {
        fiatTimer?.invalidate()
    }
    
}
