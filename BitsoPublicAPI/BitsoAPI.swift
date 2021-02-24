//
//  BitsoAPI.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import Foundation

enum BitsoAPIError: Error {
    case invalidURL
    case invalidData
    case unkownError
}

public struct BitsoAPI {
    
    public typealias BookResult = BitsoAPIResult<Book>
    public typealias TickerResult = BitsoAPIResult<Ticker>

    var requestsPerformed: Int = 0
    var timeOfLastRequest: Date?
    
    let SCHEME: String = "https"
    let HOST: String = "api-dev.bitso.com"
    let API_VERSION: String = "/v3"
    
    var isRateLimited: Bool {
        // TODO: Do not perform more than 60 requests per minute
        return false
    }
    
    enum APIAction: String {
        case availableBooks = "/available_books"
        case ticker = "ticker/"
    }
    
    public init() { }
    
    func makeURL(for action: APIAction, queryItems: [URLQueryItem]? = nil) -> URL? {
        
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = SCHEME
        urlComponents.host = HOST
        urlComponents.path = API_VERSION + action.rawValue

        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }

        return urlComponents.url
        
    }
    
    public func getAvailableBooks( closure: @escaping (Result<BookResult, Error>) -> Void) {

        guard !isRateLimited else { return }

        guard let url = makeURL(for: .availableBooks) else {
            DefaultLogger.info("Could not create url from given components")
            closure(.failure(BitsoAPIError.invalidURL))
            return
        }
        
        let request: URLRequest = .init(url: url)
        let session = URLSession.init(configuration: .default)

        let task = session.dataTask(with: request) { data, response, error in
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                guard let data = data else { return }
                
                if let result: BookResult = resultFromData(data: data) {
                    closure(.success(result))
                } else {
                    closure(.failure(BitsoAPIError.invalidData))
                }
                
            } else if let error = error {
                closure(.failure(error))
            } else {
                closure(.failure(BitsoAPIError.unkownError))
            }
        }
        
        task.resume()
    }
    
    public func getTicker(book: String, closure: @escaping (Result<TickerResult, Error>) -> Void) {

        guard !isRateLimited else { return }

        guard let url = makeURL(for: .ticker,
                                queryItems: [URLQueryItem(name: "book", value: book)]) else {
            DefaultLogger.info("Could not create url from given components")
            closure(.failure(BitsoAPIError.invalidURL))
            return
        }
        
        let request: URLRequest = .init(url: url)
        let session = URLSession.init(configuration: .default)

        let task = session.dataTask(with: request) { data, response, error in

            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                guard let data = data else { return }
                
                if let result: TickerResult = resultFromData(data: data) {
                    closure(.success(result))
                } else {
                    closure(.failure(BitsoAPIError.invalidData))
                }

            } else if let error = error {
                closure(.failure(error))
            } else {
                closure(.failure(BitsoAPIError.unkownError))
            }
        }
        
        task.resume()
        
    }
}

extension BitsoAPI {

    func resultFromData<Type>(data: Data?) -> BitsoAPIResult<Type>? {
        guard let data = data else { return nil }

        let decoder: JSONDecoder = .init()
        return try? decoder.decode(BitsoAPIResult<Type>.self, from: data)
    }
    
}
