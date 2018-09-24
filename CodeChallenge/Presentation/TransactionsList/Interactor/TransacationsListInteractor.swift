//
//  TransactionsListInteractor.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation


class TransactionsListInteractor {
    
    private let transactionsDataSource: TransactionsDataSourceInterface
    
    // MARK: - INIT
    
    init(transactionsDataSource: TransactionsDataSourceInterface) {

        self.transactionsDataSource = transactionsDataSource
    }
    
    func loadTransactions(cached: Bool, with completion: @escaping (Result<[Transaction], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.transactionsDataSource.transactionsList(cached: cached) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func deleteTransactions(transactionsIds: [TransactionId], with completion: @escaping (Result<[TransactionId], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.transactionsDataSource.deleteTransactions(transactionsIds: transactionsIds)  { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
