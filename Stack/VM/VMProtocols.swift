
protocol GridViewModelProtocol {
    var rows: Int { get }
    var cols: Int { get }
    var nodes: [Node] { get set }
}

protocol APIFetchingGridViewModelProtocol: GridViewModelProtocol {
    var networkManager: NetworkManager { get }
    func updateFinancialData()
    func updateValue<T>(using fetchFunction: (@escaping (Result<T, Error>) -> Void) -> Void,
                        onSuccess: @escaping (T) -> Void,
                        onFail: @escaping () -> Void)
    func setNodeAndPropertyFromApi(with value: Double, for property: inout Double,
                                   atColumn: Int, andRow: Int)
}
