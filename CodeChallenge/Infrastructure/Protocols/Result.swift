//
//  Result.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
