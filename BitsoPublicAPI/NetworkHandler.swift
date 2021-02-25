//
//  NetworkHandler.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/24/21.
//

import Foundation

protocol NetworkHandler {
    
    func performRequest(for url:URL,
                        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    
}

struct Router: NetworkHandler {
    
    func performRequest(for url:URL,
                        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let request: URLRequest = .init(url: url)
        let session = URLSession.init(configuration: .default)

        let task = session.dataTask(with: request, completionHandler: completionHandler)
        
        task.resume()
    }
    
}
