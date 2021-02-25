//
//  BitsoAPI.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import Foundation

public
enum BitsoAPIError: Error {
    case invalidURL
    case missingData
    case invalidData
    case unkownError
    case error(Error)
}

public
struct BitsoAPI {
    
    public typealias BookResult = BitsoAPIResult<Book>
    public typealias TickerResult = BitsoAPIResult<Ticker>

    let SCHEME: String = "https"
    let HOST: String = "api-dev.bitso.com"
    let API_VERSION: String = "/v3"
    
    let networkHandler: NetworkHandler
    
    var requestsPerformed: Int = 0
    var timeOfLastRequest: Date?
    
    var isRateLimited: Bool {
        // TODO: Do not perform more than 60 requests per minute
        return false
    }
    
    enum APIAction: String {
        case availableBooks = "/available_books"
        case ticker = "ticker/"
    }
    
    public init() {
        self.init(networkHandler: Router())
    }
    
    init(networkHandler: NetworkHandler) {
        self.networkHandler = networkHandler
    }

}

extension BitsoAPI {
    
    public func getAvailableBooks(onResult: @escaping (Result<BookResult, BitsoAPIError>) -> Void) {

        guard !isRateLimited else { return }
        
        performRequest(for: .availableBooks,
                       onResponse: onResult)
    }
    
    public func getTicker(book: String, onResult: @escaping (Result<TickerResult, BitsoAPIError>) -> Void) {

        guard !isRateLimited else { return }

        performRequest(for: .ticker,
                       queryItems: [URLQueryItem(name: "book", value: book)],
                       onResponse: onResult)
    }
    
}


extension BitsoAPI {

    private func buildURL(for action: APIAction,
                         queryItems: [URLQueryItem]? = nil) -> URL? {
        
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = SCHEME
        urlComponents.host = HOST
        urlComponents.path = API_VERSION + action.rawValue
        urlComponents.queryItems = queryItems

        return urlComponents.url
        
    }
    
    private func performRequest<Type>(for action: APIAction,
                                      queryItems: [URLQueryItem]? = nil,
                                      onResponse: @escaping (Result<BitsoAPIResult<Type>, BitsoAPIError>) -> Void) {
        
        guard let url = buildURL(for: action,
                                queryItems: queryItems) else {
            DefaultLogger.info("Could not create url from given components")
            onResponse(.failure(.invalidURL))
            return
        }
        
        networkHandler.performRequest(for: url) { data, response, error in
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {

                onResponse(resultFromData(data: data))

            } else if let error = error {
                onResponse(.failure(.error(error)))
            } else {
                onResponse(.failure(.unkownError))
            }
        }
    
    }

    private func resultFromData<Type>(data: Data?) -> Result<BitsoAPIResult<Type>, BitsoAPIError> {
        guard let data = data else {
            DefaultLogger.info("The server returned no data")
            return  .failure(.missingData)
        }

        let decoder: JSONDecoder = .init()
        do {
            let result = try decoder.decode(BitsoAPIResult<Type>.self, from: data)
            return .success(result)
        } catch {
            return .failure(.error(error))
        }
        
    }
    
}
