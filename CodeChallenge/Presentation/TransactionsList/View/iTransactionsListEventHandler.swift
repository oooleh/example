//
//  iTransactionsListEventHandler.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

protocol iTransactionsListEventHandler: class {
    
    func viewDidLoad()
    func didPullDownToRefresh()
    
    func didChangeViewMode(viewModel: TransactionsListViewModel)
    func didSelect(item: TransactionsListViewModel.Item, viewModel: TransactionsListViewModel)
    func didDeselect(item: TransactionsListViewModel.Item, viewModel: TransactionsListViewModel)
}
