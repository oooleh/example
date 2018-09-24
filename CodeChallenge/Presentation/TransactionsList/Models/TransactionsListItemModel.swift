//
//  TransactionsListItem.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

extension TransactionsListViewModel {
    
    struct Item: Equatable {
        
        let id: String
        let description: String
        let value: String
        let iconUrl: URL
        let categoryName: String?
        var isSelected: Bool = false
        
        init(transaction: Transaction) {
            self.id = transaction.id
            self.description = transaction.description
            let currencyFormatter = Formatter.formatter(currencyIso: transaction.amount.currencyIso)
            self.value = currencyFormatter.string(for: transaction.amount.value)!
            self.iconUrl = transaction.product.iconUrl
            self.categoryName = transaction.category?.name
        }
    }
}

func ==(lhs: TransactionsListViewModel.Item, rhs: TransactionsListViewModel.Item) -> Bool {
    return (lhs.id == rhs.id)
}
