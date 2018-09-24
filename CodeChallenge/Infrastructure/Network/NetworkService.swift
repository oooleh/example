//
//  NetworkService.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

protocol CancelableTask {
    func cancel()
    func resume()
}

extension URLSessionDataTask: CancelableTask { }

class NetworkOperation: CancelableTask {
    
    var request: URLRequest
    var sessionDataTask: URLSessionDataTask?
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func cancel() {
        sessionDataTask?.cancel()
    }
    
    func resume() {
        sessionDataTask?.resume()
    }
}

protocol NetworkServiceInterface {
    var config: NetworkConfigurable { get }
    
    func request(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkOperation
}

enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case notConnected
}

extension NetworkError {
    var isNotFoundError: Bool { return hasCodeError(404) }
    
    func hasCodeError(_ codeError: Int) -> Bool {
        switch self {
        case let (.errorStatusCode(code)):
            return code == codeError
        default: return false
        }
    }
}

// MARK: - Implementation

class NetworkService {
    
    let config: NetworkConfigurable
    let session: URLSession
    
    init(session: URLSession, config: NetworkConfig) {
        self.session = session
        self.config = config
    }
}

extension NetworkService: NetworkServiceInterface {
    
    func request(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkOperation {
        let operation = NetworkOperation(request: request)
        operation.sessionDataTask = session.dataTask(with: request) { (data, response, requestError) in
            
            var error: Error? = requestError
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 400..<600:
                    error = NetworkError.errorStatusCode(statusCode: response.statusCode)
                default: break
                }
            }
            
            if var error = error {
                if error._code == NSURLErrorNotConnectedToInternet {
                    error = NetworkError.notConnected
                }
                completion(nil, nil, error)
            }
            else {
                completion(data, response, nil)
            }
        }
        operation.resume()
        
        return operation
    }
}
