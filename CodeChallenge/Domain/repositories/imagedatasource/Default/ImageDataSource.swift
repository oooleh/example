//
//  ImageDataSource.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

class ImageDataSource {
    
    let dataTransferService: DataTransferInterface
    
    init(dataTransferService: DataTransferInterface) {
        self.dataTransferService = dataTransferService
    }
}

extension ImageDataSource: ImageDataSourceInterface {
    
    func image(withUrl url: URL, result: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask? {
        
        let urlRequest = URLRequest(url: url)
        return dataTransferService.request(with: urlRequest) { (response: Result<UIImage, Error>) in
            switch response {
            case .success(let image):
                result(.success(image))
                return
            case .failure(let error):
                result(.failure(error))
                return
            }
        }
    }
}
