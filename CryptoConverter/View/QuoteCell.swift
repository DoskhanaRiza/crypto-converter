//
//  QuoteCell.swift
//  CryptoConverter
//
//  Created by Admin on 10/21/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import UIKit
import SVGKit

class QuoteCell: UITableViewCell {
    
    @IBOutlet private weak var quoteImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    
    func configure(with quote: Quote, name: String, rank: Int) {

        nameLabel.text = quote.name
        priceLabel.text = quote.price
        symbolLabel.text = quote.symbol
        rankLabel.text = quote.rank
        
        let svg = URL(string: quote.logoURL!)
        quoteImage.downloadedsvg(from: svg!)
    }
    
}

extension UIImageView {
    func downloadedsvg(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
