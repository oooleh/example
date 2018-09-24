//
//  transactionsDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

protocol TransactionsDataSourceInterface {
    @discardableResult
    func transactionsList(cached: Bool, with result: @escaping (Result<[Transaction], Error>) -> Void) -> CancelableTask?
    @discardableResult
    func deleteTransactions(transactionsIds: [TransactionId], with result: @escaping (Result<[TransactionId], Error>) -> Void) -> CancelableTask?
}
