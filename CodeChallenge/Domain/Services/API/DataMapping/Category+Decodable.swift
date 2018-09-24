//
//  Category.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

struct CategoriesList {
    let categories: [Category]
}

extension CategoriesList : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case categories = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = try container.decode([Category].self, forKey: .categories)
    }
}

extension Category: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
