//
//  Amount.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

enum CurrencyIso: String {
    case gbp = "GBP"
}

struct Amount {
    let value: Float
    let currencyIso: CurrencyIso
}
