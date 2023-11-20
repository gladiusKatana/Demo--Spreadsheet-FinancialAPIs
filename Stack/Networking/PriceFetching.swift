extension NetworkManager {
    
    func fetchBitcoinPrice(completion: @escaping (Result<Double, Error>) -> Void) {
        fetchData(from: KrakenEndpoint.ticker) { (result: Result<KrakenResponse, Error>) in
            switch result {
            case .success(let response):
                if let priceString = response.result.XXBTZUSD.c.first, let price = Double(priceString) {
                    completion(.success(price))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExchangeRate(completion: @escaping (Result<Double, Error>) -> Void) {
        fetchData(from: ForexEndpoint.latest) { (result: Result<ForexResponse, Error>) in
            switch result {
            case .success(let response):
                if let cadRate = response.rates.CAD {
                    completion(.success(cadRate))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
