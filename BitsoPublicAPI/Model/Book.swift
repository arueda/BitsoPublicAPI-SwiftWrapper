//
//  Book.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

public struct Book {
    public let name: String
    public let minimumPrice: String
    public let maximumPrice: String
    public let minimumAmount: String
    public let maximumAmount: String
    public let minimumValue: String
    public let maximumValue: String
    public let tickSize: String
    public let defaultChart: String
    
    var symbols: [String] {
        name.components(separatedBy: "_")
    }
}

extension Book: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.minimumPrice = (try? container.decode(String.self, forKey: .minimumPrice)) ?? ""
        self.maximumPrice = (try? container.decode(String.self, forKey: .maximumPrice)) ?? ""
        self.minimumAmount = (try? container.decode(String.self, forKey: .minimumAmount)) ?? ""
        self.maximumAmount = (try? container.decode(String.self, forKey: .maximumAmount)) ?? ""
        self.minimumValue = (try? container.decode(String.self, forKey: .minimumValue)) ?? ""
        self.maximumValue = (try? container.decode(String.self, forKey: .maximumValue)) ?? ""
        self.tickSize = (try? container.decode(String.self, forKey: .tickSize)) ?? ""
        self.defaultChart = (try? container.decode(String.self, forKey: .defaultChart)) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "book"
        case minimumPrice = "minimum_price"
        case maximumPrice = "maximum_price"
        case minimumAmount = "minimum_amount"
        case maximumAmount = "maximum_amount"
        case minimumValue = "minimum_value"
        case maximumValue = "maximum_value"
        case tickSize = "tick_size"
        case defaultChart = "default_chart"
    }
}

extension Book: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        \n== BOOK ==
        name: \(name)
        minimumPrice: \(minimumPrice)
        maximumPrice: \(maximumPrice)
        minimumAmount: \(minimumAmount)
        maximumAmount: \(maximumAmount)
        minimumValue: \(minimumValue)
        maximumValue: \(maximumValue)
        tickSize: \(tickSize)
        defaultChart: \(defaultChart)
        == == ==\n
        """
    }
}
