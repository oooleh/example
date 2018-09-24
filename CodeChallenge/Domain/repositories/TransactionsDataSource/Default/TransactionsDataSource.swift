//
//  transactionsDataSource.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

struct Storage<T: Hashable> {
    
    private(set) var items: Set<T> = Set<T>()
    
    mutating func insert(_ item: T) {
        items.insert(item)
    }
    mutating func remove(_ item: T) {
        items.remove(item)
    }
    mutating func removeAll() {
        items.removeAll()
    }
}

class TransactionsDataSource {
    
    private let dataTransferService: DataTransferInterface
    private let categoriesDataSource: CategoriesDataSourceInterface
    private var cache: Storage<Transaction>
    private var deleted: Storage<TransactionId> // Sync with server
    
    init(dataTransferService: DataTransferInterface,
         categoriesDataSource: CategoriesDataSourceInterface,
         cache: Storage<Transaction>,
         deleted: Storage<TransactionId>) {
        self.dataTransferService = dataTransferService
        self.categoriesDataSource = categoriesDataSource
        self.cache = cache
        self.deleted = deleted
    }
}

extension TransactionsDataSource: TransactionsDataSourceInterface {

    func transactionsList(cached: Bool, with result: @escaping (Result<[Transaction], Error>) -> Void) -> CancelableTask? {
        let endpoint = APIEndpoints.transactions().config
        
        if cached {
            result(.success(filterOutDeleted(cache.items) ))
            return nil
        }
        
        return categoriesDataSource.categoriesList() { (response: Result<[Category], Error>) in
            switch response {
            case .success(let categories):
                self.dataTransferService.request(with: endpoint) { [weak self] (response: Result<TransactionsList, Error>) in
                    guard let weakSelf = self else { return }
                    switch response {
                    case .success(let TransactionsList):
                        weakSelf.cache.removeAll()
                        for var transaction in TransactionsList.transactions {
                            transaction.category = categories.filter{ $0.id == transaction.categoryId }.first
                            weakSelf.cache.insert(transaction)
                        }
                        result(.success(weakSelf.filterOutDeleted(weakSelf.cache.items) ))
                        return
                    case .failure(let error):
                        result(.failure(error))
                        return
                    }
                }
            case .failure(let error):
                result(.failure(error))
                return
            }
        }
    }
    
    func deleteTransactions(transactionsIds: [TransactionId], with result: @escaping (Result<[TransactionId], Error>) -> Void) -> CancelableTask? {
        transactionsIds.forEach { deleted.insert($0) }
        result(.success(transactionsIds))
        return nil
    }
    
    private func filterOutDeleted(_ set: Set<Transaction>) -> [Transaction] {
        return set.filter { !deleted.items.contains($0.id) }
    }
}
