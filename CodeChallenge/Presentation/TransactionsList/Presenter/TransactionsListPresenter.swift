//
//  TransactionsListPresenter.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

class TransactionsListPresenter {
        
    var wireframe: TransactionsListWireframe
    var interactor: TransactionsListInteractor

    weak var viewController: TransactionsListViewController?
    
    // MARK: - INIT
    
    init(wireframe: TransactionsListWireframe, interactor: TransactionsListInteractor) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
    
    func updateView(loadingType: TransactionsListViewModel.LoadingType, withCachedData cached: Bool = true) {
        
        var oldViewModel = viewController?.viewModel
        oldViewModel?.loadingType = loadingType
        viewController?.updateViewModel(oldViewModel)
        
        self.interactor.loadTransactions(cached: cached) { [weak self] result in
            oldViewModel?.loadingType = .none
            self?.viewController?.updateViewModel(oldViewModel)
            switch result {
            case .success(let transactions):
                let viewModel = self?.getNewViewModel(transactions: transactions)
                self?.viewController?.updateViewModel(viewModel)
                return
            case .failure(let error):
                let userErrorMessage = (error is NetworkError) ? TransactionsListViewModel.errorNoConnection : TransactionsListViewModel.errorFailedReloading
                self?.viewController?.showError(userErrorMessage)
                return
            }
        }
    }
    
    func getNewViewModel(transactions: [Transaction]) -> TransactionsListViewModel? {
        
        return TransactionsListViewModel(transactions: transactions)
    }
}

extension TransactionsListPresenter : iTransactionsListEventHandler {

    func viewDidLoad() {
        updateView(loadingType: .fullScreen, withCachedData: false)
    }
    
    func didPullDownToRefresh() {
        updateView(loadingType: .pullToRefresh, withCachedData: false)
    }
    
    func didChangeViewMode(viewModel: TransactionsListViewModel) {
        guard !viewModel.isLoading else { return }
        var newViewModel = viewModel
        if viewModel.mode == .edition, viewModel.selectedItems.count > 0 {
            self.interactor.deleteTransactions(transactionsIds: viewModel.selectedItems.map { $0.id }) { [weak self] result in
                switch result {
                case .success:
                    self?.updateView(loadingType: .none)
                    return
                case .failure(let error):
                    let userErrorMessage = (error is NetworkError) ? TransactionsListViewModel.errorNoConnection : TransactionsListViewModel.errorFailedReloading
                    self?.viewController?.showError(userErrorMessage)
                    return
                }
            }
        }
        
        newViewModel.swapMode()
        viewController?.updateViewModel(newViewModel)
    }
    
    func didSelect(item: TransactionsListViewModel.Item, viewModel: TransactionsListViewModel) {
        var newViewModel = viewModel
        if viewModel.mode == .edition {
            newViewModel.setItem(item: item, isSelected: true)
        }
        self.viewController?.updateViewModel(newViewModel)
    }
    
    func didDeselect(item: TransactionsListViewModel.Item, viewModel: TransactionsListViewModel) {
        var newViewModel = viewModel
        if viewModel.mode == .edition {
            newViewModel.setItem(item: item, isSelected: false)
        }
        self.viewController?.updateViewModel(newViewModel)
    }
}
