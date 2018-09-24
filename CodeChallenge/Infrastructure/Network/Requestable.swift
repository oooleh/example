//
//  Requestable.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod? { get }
    var queryParameters: [String: String?]? { get }
    var body: [String: String?]? { get }
    var headerParamaters: [String: String]? { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    func url(with config: NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.last != "/" ? config.baseURL + "/" : config.baseURL
        let endpoint = baseURL.appending(self.path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components}
        var urlQueryItems = [URLQueryItem]()
        
        if let queryItems = self.queryParameters {
            queryItems.forEach({
                urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            })
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url  = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String : String] = config.headers
        if let headers = self.headerParamaters {
            headers.forEach({ allHeaders.updateValue($1, forKey: $0) })
        }
        if let bodyParams = self.body {
            let jsonBody = try? JSONSerialization.data(withJSONObject: bodyParams)
            urlRequest.httpBody = jsonBody
        }
        urlRequest.httpMethod = (self.method ?? .get).rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}
