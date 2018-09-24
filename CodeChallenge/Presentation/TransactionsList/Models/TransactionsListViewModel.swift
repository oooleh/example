//
//  TransactionsListViewModel.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

private extension Sequence where Element == Transaction {
    func mapToItems() -> [TransactionsListViewModel.Item] {
        return map{ TransactionsListViewModel.Item(transaction: $0) }
    }
}

private extension Sequence where Element == Transaction {
    var sortedTransactions: [Transaction] {
        return sorted(by: { $0.date > $1.date })
    }
}

struct TransactionsListViewModel {
    
    enum ViewMode {
        case normal
        case edition        
    }

    enum LoadingType {
        case none
        case fullScreen
        case pullToRefresh
    }
    
    var mode: ViewMode = .normal

    var allowsMultipleSelection: Bool { return mode == .edition }
    var itemsSelectionColor: UIColor { return mode == .normal ? AppColors.lightGray : AppColors.lightRed }
    var isPullToRefreshControlEnabled: Bool { return mode == .normal }
    var isEditButtonEnabled: Bool { return !isEmpty }

    private(set) var items: [Item]
    var selectedItems: [Item] {
        return items.filter { return $0.isSelected }
    }
    var isEmpty: Bool { return items.isEmpty }
    var isLoading: Bool { return loadingType != .none }
    var loadingType: LoadingType = .none

    init(transactions: [Transaction]? = nil) {
        guard let transactions = transactions else {
            self.items = []
            return
        }
        self.items = transactions.sortedTransactions.mapToItems()
    }

    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard section < numberOfSections else { return 0 }
        return !isEmpty ? items.count: 1
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        return items[indexPath.row]
    }
    
    mutating func swapMode() {
        self.mode = mode == .normal ? .edition : .normal
        deselectAllItems()
    }
    
    mutating func deselectAllItems() {
        for index in 0..<items.count {
            items[index].isSelected = false
        }
    }
    
    mutating func setItem(item: Item, isSelected: Bool) {
        guard let index = items.index(of: item) else { return }
        items[index].isSelected = isSelected
    }
}

extension TransactionsListViewModel {
    static let title = NSLocalizedString("Transactions", comment: "")
    static let emptyListTitle = NSLocalizedString("You list is empty.\nPlease Pull to refresh", comment: "")
    static let errorTitle = NSLocalizedString("Error", comment: "")
    static let errorNoConnection = NSLocalizedString("No internet connection", comment: "")
    static let errorFailedReloading = NSLocalizedString("Failed reloading transactions", comment: "")
    static let errorFailedDeleting = NSLocalizedString("Failed deleting transactions", comment: "")
    static let pullToRequestTitle = NSLocalizedString("Pull to refresh", comment: "")
    
    var editButtonTitle: String {
        switch mode {
        case .normal:
            return NSLocalizedString("Edit", comment: "")
        case .edition:
            return NSLocalizedString("Done", comment: "")
        }
    }
}
