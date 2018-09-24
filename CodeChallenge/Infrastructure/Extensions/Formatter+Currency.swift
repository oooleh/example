//
//  Formator.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

fileprivate extension Locale {
    static let uk = Locale(identifier: "en_UK")
}

extension Formatter {
    static let currencyUK = NumberFormatter(style: .currency, locale: .uk)
    
    static func formatter(currencyIso: CurrencyIso) -> Formatter {
        switch currencyIso {
        case .gbp:
            return currencyUK
        }
    }
}

fileprivate extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        numberStyle = style
    }
}
