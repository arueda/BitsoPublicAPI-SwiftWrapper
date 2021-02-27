//
//  BitsoAPIResult.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

public struct BitsoAPIResult<Type: Decodable> {
    public let success: Bool
    public let payload: Type
}

extension BitsoAPIResult: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.payload = try container.decode(Type.self, forKey: .payload)
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case payload
    }
}
