//
//  Product+Decodable.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

extension Product: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case iconUrl = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.iconUrl = try container.decode(URL.self, forKey: .iconUrl)
    }
}
