import Foundation

class NetworkManager {
    private var currentTask: URLSessionTask?
    
    func cancelCurrentTask() {
        currentTask?.cancel()
    }
    
    func fetchData<T: Decodable>(from endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(endpoint.baseUrl)\(endpoint.path)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
    
}
