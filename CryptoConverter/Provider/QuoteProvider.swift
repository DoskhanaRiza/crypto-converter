//
//  Service.swift
//  CryptoConverter
//
//  Created by Riza on 11/15/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteProvider {
    
    func performRequest(completion: @escaping ([Quote]) -> Void) {
        let urlString = "https://api.nomics.com/v1/currencies/ticker?key=3c8c0907276523d0ff0e94c50657de0c&format=json&interval=5m&convert=USD"
        if let url = URL(string: urlString) {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let quotes = try jsonDecoder.decode([Quote].self, from: data)
                        completion(quotes)
                    } catch {
                        print(error)
                    }
                }
                if let error = error {
                    print(error)
                }
            }
            dataTask.resume()
        }
     
    }
    
}
