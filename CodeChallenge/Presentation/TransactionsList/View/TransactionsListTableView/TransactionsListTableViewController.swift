//
//  TransactionsListTableViewController.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

class TransactionsListTableViewController: UITableViewController {
    
    weak var eventHandler: iTransactionsListEventHandler?
    var viewModel = TransactionsListViewModel()
    var imageDataSource: ImageDataSourceInterface!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: TransactionsListViewModel.pullToRequestTitle)
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func reload() {
        tableView.reloadData()
        tableView.allowsMultipleSelection = viewModel.allowsMultipleSelection
        setRefreshControl(enabled: viewModel.isPullToRefreshControlEnabled)
        setRefreshControl(isLoading: viewModel.loadingType == .pullToRefresh)
    }
    
    private func setRefreshControl(enabled: Bool) {
        guard let refreshControl = refreshControl else { return }
        if enabled {
            tableView.addSubview(refreshControl)
        } else {
            refreshControl.removeFromSuperview()
        }
    }
    
    private func setRefreshControl(isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            endRefreshing()
        }
    }
    
    private func endRefreshing() {
        guard let refreshControl = refreshControl else { return }
        if refreshControl.isRefreshing {
            tableView.setContentOffset(.zero, animated: true)
            refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        eventHandler?.didPullDownToRefresh()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TransactionsListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !viewModel.isEmpty else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsListEmptyDataCell.reuseIdentifier, for: indexPath) as! TransactionsListEmptyDataCell
            cell.descriptionLabel.text = TransactionsListViewModel.emptyListTitle
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsListItemCell.reuseIdentifier, for: indexPath) as! TransactionsListItemCell
        
        if let item = viewModel.item(at: indexPath) {
            cell.fill(with: item, imageDataSource: imageDataSource, selectionColor: viewModel.itemsSelectionColor)
            if item.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel.item(at: indexPath) {
            eventHandler?.didSelect(item: item, viewModel: viewModel)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let item = viewModel.item(at: indexPath) {
            eventHandler?.didDeselect(item: item, viewModel: viewModel)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
}
