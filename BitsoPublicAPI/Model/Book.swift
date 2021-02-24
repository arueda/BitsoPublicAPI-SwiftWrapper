//
//  Book.swift
//  BitsoPublicAPI
//
//  Created by Angel Alberto Rueda Mejia on 2/23/21.
//

import Foundation

struct Book {
    let book: String
    let minimumPrice: String
    let maximumPrice: String
    let minimumAmount: String
    let maximumAmount: String
    let minimumValue: String
    let maximumValue: String
    let tickSize: String
    let defaultChart: String

}

extension Book: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.book = (try? container.decode(String.self, forKey: .book)) ?? ""
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
        case book
        case minimumPrice = "minimum_price"
        case maximumPrice = "maximum_price"
        case minimumAmount = "minimum_amount"
        case maximumAmount = "maximum_amount"
        case minimumValue = "minimum_value"
        case maximumValue = "maximum_value"
        case tickSize = "tick_size"
        case defaultChart = "defaultChart"
    }
}
