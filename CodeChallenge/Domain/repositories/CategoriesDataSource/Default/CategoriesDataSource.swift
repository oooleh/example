//
//  CategoriesDataSource.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

enum CategoriesDataSourceError: Error {
    case filePath
    case parsingData
}

class CategoriesDataSource {
    private let path = Bundle.main.path(forResource: "Categories", ofType: "plist")
}

extension CategoriesDataSource: CategoriesDataSourceInterface {
    
    func categoriesList(with result: @escaping (Result<[Category], Error>) -> Void) -> CancelableTask? {
        
        guard let path = path else {
            result(.failure(CategoriesDataSourceError.filePath))
            return nil
        }
        let url = URL(fileURLWithPath: path)
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data(contentsOf: url),
            let categoriesList = try? decoder.decode(CategoriesList.self, from: data) else {
            result(.failure(CategoriesDataSourceError.parsingData))
            return nil
        }
        result(.success(categoriesList.categories))
        return nil
    }
}

