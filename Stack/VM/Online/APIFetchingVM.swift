import SwiftUI

class APIFetchingGridViewModel: GridViewModel, APIFetchingGridViewModelProtocol {
    let networkManager = NetworkManager()
    
    override init(cols: Int, rows: Int) {
        super.init(cols: cols, rows: rows)
        self.updateFinancialData()
    }
    
    func updateFinancialData() { } /// stub for satisfying protocol - implement as needed for each spreadsheet-like view that fetches API data
    
    func updateValue<T>(
        using fetchFunction: (@escaping (Result<T, Error>) -> Void) -> Void,
        onSuccess: @escaping (T) -> Void,
        onFail: @escaping () -> Void
    ) {
        fetchFunction { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { onSuccess(data) }
            case .failure(let error):
                DispatchQueue.main.async { onFail() }
                print("Failed to fetch data:", error.localizedDescription)
            }
        }
    }
    
    func setNodeAndPropertyFromApi(with value: Double, for property: inout Double,
                                   atColumn column: Int, andRow row: Int) {
        property = value
        let index = index(from: column,row)
        if nodes.count > index {
            nodes[index].value = value
            nodes[index].changes.viaAPI += 1
            nodes[index].isSetFromRestAPI = true
        }
    }
    
    deinit {
        networkManager.cancelCurrentTask()
    }
}
