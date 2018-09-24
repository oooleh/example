//
//  Endpoint.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

struct Endpoint: Requestable {
    var path: String
    var method: HTTPMethod? = .get
    var queryParameters: [String: String?]? = nil
    var headerParamaters: [String: String]? = nil
    var body: [String : String?]? = nil
    
    init(path: String,
         method: HTTPMethod? = .get,
         queryParameters: [String: String?]? = nil,
         headerParamaters: [String: String]? = nil,
         body: [String : String?]? = nil) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.headerParamaters = headerParamaters
        self.body = body
    }
}
