//
//  DIContainer.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import  UIKit

class DIContainer {
    
    static let shared = DIContainer()
    
    // MARK: - Network
    let networkService: NetworkServiceInterface
    let dataTransferService: DataTransferInterface
    
    // MARK: - Data Sources
    lazy var imageDataSource: ImageDataSourceInterface = {
        return ImageDataSource(dataTransferService: dataTransferService)
    }()
    
    lazy var transactionsDataSource: TransactionsDataSourceInterface = {
        return TransactionsDataSource(dataTransferService: dataTransferService,
                                      categoriesDataSource: categoriesDataSource,
                                      cache: Storage<Transaction>(),
                                      deleted: Storage<TransactionId>())
    }()
    
    lazy var categoriesDataSource: CategoriesDataSourceInterface = {
        return CategoriesDataSource()
    }()
    
    init() {
        let networkConfig = NetworkConfig()
        networkService = NetworkService(session: URLSession.shared, config: networkConfig)
        dataTransferService = DataTransferService(with: networkService)
    }
}
