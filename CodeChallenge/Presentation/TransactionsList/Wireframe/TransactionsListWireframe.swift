//
//  TransactionsListWireframe.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import  UIKit

protocol TransactionsListDependencies {
    var imageDataSource: ImageDataSourceInterface { get }
    var transactionsDataSource: TransactionsDataSourceInterface { get }
}

extension DIContainer: TransactionsListDependencies {}

class TransactionsListWireframe {

    private weak var presenter: TransactionsListPresenter?
    
    class func assemble(dependencies: TransactionsListDependencies, forView viewController: TransactionsListViewController) -> UIViewController {
        
        let wireframe = TransactionsListWireframe()
        let interactor = TransactionsListInteractor(transactionsDataSource: dependencies.transactionsDataSource)
        
        let presenter = TransactionsListPresenter(wireframe: wireframe, interactor: interactor)
        presenter.viewController = viewController
        viewController.eventHandler = presenter
        viewController.imageDataSource = dependencies.imageDataSource
        wireframe.presenter = presenter
        
        return viewController
    }
}

