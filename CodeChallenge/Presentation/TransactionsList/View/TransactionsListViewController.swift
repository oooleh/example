//
//  TransactionsListViewController.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

class TransactionsListViewController: UIViewController, Alertable {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private var tableViewController: TransactionsListTableViewController?
    var imageDataSource: ImageDataSourceInterface!
    var eventHandler: iTransactionsListEventHandler? {
        didSet {
            tableViewController?.eventHandler = eventHandler
        }
    }
    var viewModel: TransactionsListViewModel? {
        get { return tableViewController?.viewModel }
        set {
            tableViewController?.viewModel = newValue ?? TransactionsListViewModel()
        }
    }
    var isFullScreenLoading: Bool = false {
        didSet {
            if isFullScreenLoading {
                contentView.isHidden = true
                loadingView.isHidden = false
            }
            else {
                contentView.isHidden = false
                loadingView.isHidden = true
            }
        }
    }
    
    func updateViewModel(_ model: TransactionsListViewModel?) {
        viewModel = model
        isFullScreenLoading = model?.loadingType == .fullScreen
        tableViewController?.reload()
        setupEditButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        title = TransactionsListViewModel.title
        setupEditButton()
    }
    
    @objc func editTapped(sender: AnyObject) {
        guard let viewModel = viewModel else { return }
        eventHandler?.didChangeViewMode(viewModel: viewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: TransactionsListTableViewController.self),
            let destinationVC = segue.destination as? TransactionsListTableViewController {
            tableViewController = destinationVC
            tableViewController?.eventHandler = eventHandler
            tableViewController?.imageDataSource = imageDataSource
            if let viewModel = viewModel {
                self.tableViewController?.viewModel = viewModel
            }
            tableViewController?.reload()
        }
    }

    func setupEditButton() {
        guard let viewModel = viewModel else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.editButtonTitle, style: .done, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isEditButtonEnabled
    }
    
    func showError(_ error: String) {
        showAlert(title: TransactionsListViewModel.errorTitle, message: error)
    }
}
