//
//  ImageDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit


protocol ImageDataSourceInterface {
    
    func image(withUrl url: URL, result: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask?
}
