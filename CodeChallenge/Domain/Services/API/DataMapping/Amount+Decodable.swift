//
//  Amount+Decodable.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

extension CurrencyIso: Decodable {}

extension Amount: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case value
        case currencyIso = "currency_iso"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Float.self, forKey: .value)
        self.currencyIso = try container.decode(CurrencyIso.self, forKey: .currencyIso)
    }
}
