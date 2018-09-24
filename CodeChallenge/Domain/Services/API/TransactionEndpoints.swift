//
//  TransactionEndpoints.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

enum APIEndpoints {
    
    case transactions()
    
    var config: Endpoint {
        switch self {
            
        case .transactions():
            return Endpoint(path: "v2/5b33bdb43200008f0ad1e256")
        }
    }
}
