//
//  Quote.swift
//  CryptoConverter
//
//  Created by Admin on 10/19/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import Foundation
import UIKit

class Quote: CustomStringConvertible, Decodable {
    
    let name: String
    let currency: String
    let price: String
    var priceFloat: Float {
        Float(price) ?? 0
    }
    let symbol: String?
    let logoURL: String?
    let rank: String?
    let priceDate: String?
    let priceStamp: String?
    let marketCap: String?
    let circulatingSupply: String?
    let maxSupply: String?

    private enum CodingKeys: String, CodingKey {
        case currency
        case name
        case price
        case symbol
        case logoURL = "logo_url"
        case rank
        case priceDate = "price_date"
        case priceStamp = "price_timestamp"
        case marketCap = "market_cap"
        case circulatingSupply = "circulating_ supply"
        case maxSupply = "max_supply"
        
    }
    
    var description: String {
        return "Name: \(name)\nPrice: \(price)\nSymbol: \(symbol ?? "")\nLogo URL: \(logoURL ?? "")\nRank: \(rank ?? "")\nPrice Date: \(priceDate ?? "0.0")\nPrice Stamp: \(priceStamp ?? "0.0")\nMarket Cap: \(marketCap ?? "0.0")\nCirculating Supply: \(circulatingSupply ?? "0")\nMax Supply: \(maxSupply ?? "0")"
    }
    
    
}


