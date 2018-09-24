//
//  Transaction+Decodable.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

struct TransactionsList {
    let transactions: [Transaction]
}

extension TransactionsList : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case transactions = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
}

extension Transaction: Decodable {
    private enum CodingKeys: String, CodingKey {
        
        case id
        case description
        case date
        case amount
        case product
        case categoryId = "category_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        let dateString = try container.decode(String.self, forKey: .date)
        if let mappedDate = DateFormatter.yyyyMMdd.date(from: dateString) {
            date = mappedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                   in: container,
                                                   debugDescription: "Date string does not match format")
        }
        self.product = try container.decode(Product.self, forKey: .product)
        self.amount = try container.decode(Amount.self, forKey: .amount)
        self.categoryId = try container.decode(Int.self, forKey: .categoryId)
    }
}



fileprivate extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
