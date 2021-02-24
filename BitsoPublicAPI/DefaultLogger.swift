//
//  DefaultLogger.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/22/21.
//

import Foundation

public class DefaultLogger {
    
    static let instance: SimpleLogger = DefaultLogger()
    
    static func info(_ string: String) {
        instance.info(string)
    }
}

extension DefaultLogger: SimpleLogger {
    func info(_ string: String) {
        print(string)
    }
}
