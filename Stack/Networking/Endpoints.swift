protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
}

enum KrakenEndpoint: Endpoint {
    case ticker
    var baseUrl: String { "https://api.kraken.com" }
    var path: String {
        switch self {
        case .ticker: return "/0/public/Ticker?pair=XBTUSD"
        }
    }
}

enum ForexEndpoint: Endpoint {
    case latest
    var baseUrl: String { "https://open.er-api.com" }
    var path: String {
        switch self {
        case .latest: return "/v6/latest/USD"
        }
    }
}
