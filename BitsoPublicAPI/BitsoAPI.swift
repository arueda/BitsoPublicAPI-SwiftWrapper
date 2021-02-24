//
//  BitsoAPI.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import Foundation

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
    
    public func getAvailableBooks() {

        guard !isRateLimited else { return }
        
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = SCHEME
        urlComponents.host = HOST
        urlComponents.path = API_VERSION + APIAction.availableBooks.rawValue
        
        guard let url = urlComponents.url else {
            DefaultLogger.info("Could not create url from given components")
            return
        }
        
        let request: URLRequest = .init(url: url)
        
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("\(error)")
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                guard let data = data else { return }
                
                print("\(String(data: data, encoding: .utf8) ?? "")")
            }
        }
        
        task.resume()
    }
}
