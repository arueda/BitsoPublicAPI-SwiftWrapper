//
//  BookResult.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

public struct BookResult {
    public let success: Bool
    public let payload: [Book]
}

extension BookResult: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = (try? container.decode(Bool.self, forKey: .success)) ?? false
        self.payload = (try? container.decode([Book].self, forKey: .payload)) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case payload
    }
}
