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
    
    let devServer = "https://api-dev.bitso.com/v3"
    var requestsPerformed: Int = 0
    var timeOfLastRequest: Date?
    
    let SCHEME: String = "https"
    let HOST: String = "api.bitso.com"
    let API_VERSION: String = "/v3"
    
    var isRateLimited: Bool {
        // Do not perform more than 60 requests per second
        return false
    }
    
    enum APIAction: String {
        case availableBooks = "/available_books"
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
}
