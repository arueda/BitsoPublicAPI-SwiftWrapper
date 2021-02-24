//
//  BitsoAPI.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import Foundation

enum BitsoAPIError: Error {
    case invalidURL
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
        // Do not perform more than 60 requests per second
        return false
    }
    
    enum APIAction: String {
        case availableBooks = "/available_books"
        case ticker = "ticker/"
    }
    
    public init() { }
    
    public func getAvailableBooks( closure: @escaping (Result<BookResult, Error>) -> Void) {

        guard !isRateLimited else { return }
        
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = SCHEME
        urlComponents.host = HOST
        urlComponents.path = API_VERSION + APIAction.availableBooks.rawValue
        
        guard let url = urlComponents.url else {
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
                
                do {
                    let bookResult: BookResult = try JSONDecoder().decode(BookResult.self,
                                                                          from: data)
                    closure(.success(bookResult))
                } catch {
                    closure(.failure(error))
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
        
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = SCHEME
        urlComponents.host = HOST
        urlComponents.path = API_VERSION + APIAction.ticker.rawValue
        urlComponents.queryItems = [URLQueryItem(name: "book", value: book)]
        
        guard let url = urlComponents.url else {
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
                
                do {
                    let tickerResult: TickerResult = try JSONDecoder().decode(TickerResult.self,
                                                                            from: data)
                    closure(.success(tickerResult))
                } catch {
                    closure(.failure(error))
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
