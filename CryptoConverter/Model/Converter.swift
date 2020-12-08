//
//  Converter.swift
//  CryptoConverter
//
//  Created by Admin on 10/19/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import Foundation

class Converter {
    
    let baseQuote: Quote
    
    init(baseQuote: Quote) {
        self.baseQuote = baseQuote
    }
    
    func convert(convertQuote: Quote, amount: Float) -> Float? {
        
        let convertedAmount = (amount * convertQuote.priceFloat) / (baseQuote.priceFloat)
        return convertedAmount
        
    }
    
}
