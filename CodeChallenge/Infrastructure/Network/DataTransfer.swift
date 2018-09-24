//
//  Dispatcher.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

enum DataTransferError: Error {
    case noResponse
    case parsingJSON
    case parsingImage
    case generatingUrlRequest
}

protocol DataTransferInterface {
    @discardableResult
    func request<T: Decodable>(with endpoint: Requestable, completion: @escaping (Result<T, Error>) -> Void) -> CancelableTask?
    @discardableResult
    func request(with endpoint: Requestable, completion: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask?
    @discardableResult
    func request(with urlRequest: URLRequest, completion: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask?
}

class DataTransferService {
    
    private let networkService: NetworkServiceInterface

    init(with networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
}

extension DataTransferService: DataTransferInterface {
    
    func request<T: Decodable>(with endpoint: Requestable, completion: @escaping (Result<T, Error>) -> Void) -> CancelableTask? {
        do {
            let urlRequest = try endpoint.urlRequest(with: self.networkService.config)

            let task = self.networkService.request(request: urlRequest) { (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async { completion(Result.failure(error)) }
                    return
                }
                guard let responseData = data
                    else {
                        DispatchQueue.main.async { completion(Result.failure(DataTransferError.noResponse)) }
                        return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: responseData)
                    DispatchQueue.main.async { completion(.success(result)) }
                }
                catch {
                    DispatchQueue.main.async { completion(Result.failure(DataTransferError.parsingJSON)) }
                }
            }
            task.resume()
            return task
        } catch {
            completion(Result.failure(error))
            return nil
        }
    }
    
    func request(with endpoint: Requestable, completion: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask? {
        do {
            let urlRequest = try endpoint.urlRequest(with: self.networkService.config)
            return request(with: urlRequest, completion: completion)
        } catch {
            completion(Result.failure(error))
            return nil
        }
    }
    
    func request(with urlRequest: URLRequest, completion: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask? {
        
        let task = self.networkService.request(request: urlRequest) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async { completion(Result.failure(error)) }
                return
            }
            guard let responseData = data
                else {
                    DispatchQueue.main.async { completion(Result.failure(DataTransferError.noResponse)) }
                    return
            }
            
            if let image = UIImage(data: responseData) {
                DispatchQueue.main.async { completion(Result.success(image)) }
            }
            else {
                DispatchQueue.main.async { completion(Result.failure(DataTransferError.parsingImage)) }
            }
        }
        task.resume()
        return task
    }
}
