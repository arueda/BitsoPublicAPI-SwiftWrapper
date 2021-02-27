//
//  TickerResult.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

public struct Ticker {
    let book: String
    let volume: String
    let high: String
    let last: String
    let low: String
    let vwap: String
    let ask: String
    let bid: String
    let createdAt: String
}

extension Ticker: Decodable {
    enum CodingKeys: String, CodingKey {
        case book
        case volume
        case high
        case last
        case low
        case vwap
        case ask
        case bid
        case createdAt = "created_at"
        
    }
}
