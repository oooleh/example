//
//  ServiceConfig.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: String { get }
    var headers: [String: String] { get set }
}

struct NetworkConfig: NetworkConfigurable {
    private(set) var baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    
    var headers: [String: String] = [:]
}
