//
//  OrderBook.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/25/21.
//

import Foundation

public struct OrderBook {
    let asks: [Ask]
    let bids: [Bid]
    let updatedAt: String
    let sequence: String
}

extension OrderBook: Decodable {
    enum CodingKeys: String, CodingKey {
        case asks
        case bids
        case updatedAt = "updated_at"
        case sequence
    }
}

extension OrderBook: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        == ORDER BOOK ==
        UPDATED AT: \(updatedAt)
        SEQUENCE: \(sequence)
        ASKS: \(asks)
        BIDS: \(bids)
        == == ==
        """
    }
}

public struct Ask {
    let book: String
    let price: String
    let amount: String
}

extension Ask: Decodable {}

extension Ask: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        \n== ASK ==
        BOOK: \(book)
        PRICE: \(price)
        AMOUNT: \(amount)
        == == ==
        \n
        """
    }
}

public struct Bid {
    let book: String
    let price: String
    let amount: String
}

extension Bid: Decodable {}

extension Bid: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        \n== BID ==
        BOOK: \(book)
        PRICE: \(price)
        AMOUNT: \(amount)
        == == ==
        \n
        """
    }
}
