//
//  AppRouter.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

final class AppRouter {
    
    static let shared = AppRouter()
    
    private var window: UIWindow?
    
    weak var mainNavigationController : UINavigationController?
    
    func configure(window: UIWindow?) {
        self.window = window
    }
    
    func presentTransactionsListScreen() {
        
        if let navController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController {
            
            mainNavigationController = navController
            
            if let transactionListViewController = self.mainNavigationController?.topViewController as? TransactionsListViewController {
                _ = TransactionsListWireframe.assemble(dependencies: DIContainer.shared, forView: transactionListViewController)
            }
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
}
