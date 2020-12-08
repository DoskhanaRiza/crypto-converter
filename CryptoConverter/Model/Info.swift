//
//  info.swift
//  CryptoConverter
//
//  Created by Riza on 12/3/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import Foundation

struct Info: CustomStringConvertible {
    
    let name: String = "Riza Doskhana"
    let number: String = "+7(747) 116 57 40"
    let city: String = "Karagandy"
    let dateOfBirth: String = "27.01.1994"
    let mail: String = "doskhana49@gmail.com"
    
    var description: String {
        return "Name: \(name)\nNumber: \(number)\nMail: \(mail)\nCity: \(city)\nDate of birth: \(dateOfBirth)\n"
    }
    
}

