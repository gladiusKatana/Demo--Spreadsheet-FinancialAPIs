import SwiftUI

class BitcoinAPIViewModel: APIFetchingGridViewModel {
    var bitcoinTimer: Timer?
    @Published var bitcoinPriceUSD: Double = 0
    
    override func updateFinancialData() {
        
        getBitcoinPriceWithTimer()
    }
    
    func getBitcoinPriceWithTimer() {
        self.getBitcoinPrice() /// immediately fetch the price when the timer starts
        bitcoinTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.getBitcoinPrice()
        }
    }
    
    private func getBitcoinPrice() { // helper func.
        updateValue(
            using: networkManager.fetchBitcoinPrice,
            onSuccess: { price in
                self.setNodeAndPropertyFromApi(with: price, for: &self.bitcoinPriceUSD,
                                               atColumn: 0, andRow: 0)
            },
            onFail: { self.bitcoinPriceUSD = 6.15 } /// default value
        )
    }
    
    deinit {
        bitcoinTimer?.invalidate()
    }
    
}
