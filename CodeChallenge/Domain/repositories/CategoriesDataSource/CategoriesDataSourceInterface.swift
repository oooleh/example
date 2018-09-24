//
//  CategoriesDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

protocol CategoriesDataSourceInterface {
    @discardableResult
    func categoriesList(with result: @escaping (Result<[Category], Error>) -> Void) -> CancelableTask?
}
