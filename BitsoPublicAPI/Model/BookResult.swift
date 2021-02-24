//
//  BookResult.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

struct BookResult {
    let success: Bool
    let payload: [Book]
}

extension BookResult: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = (try? container.decode(Bool.self, forKey: .succes)) ?? false
        self.payload = (try? container.decode([Book].self, forKey: .payload)) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case succes
        case payload
    }
}
