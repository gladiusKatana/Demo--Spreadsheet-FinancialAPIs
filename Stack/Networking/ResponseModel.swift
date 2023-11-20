import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case parsingError
}

//Bitcoin
struct KrakenResponse: Codable {
    let result: KrakenResult
}
struct KrakenResult: Codable {
    let XXBTZUSD: KrakenBitcoin
}
struct KrakenBitcoin: Codable {
    let c: [String] /// last trade closed price
}

//fiat
struct ForexResponse: Codable {
    let rates: Rates // let base: String? // let date: String?
}
struct Rates: Codable {
    let CAD: Double?
    let EUR: Double?
    let JPY: Double?
}
