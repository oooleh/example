//
//  Transaction.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

typealias TransactionId = String

struct Transaction {
    let id: TransactionId
    let description: String
    let date: Date
    let amount: Amount
    let product: Product
    let categoryId: Int
    var category: Category? = nil
}

extension Transaction: Equatable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension Transaction: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
