//
//  QuotesDetailViewController.swift
//  CryptoConverter
//
//  Created by Admin on 10/19/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import UIKit

class QuoteDetailsViewController: UIViewController {

    var quoteDetails: String?
    var quoteImage: UIImage?
    var quote: Quote?
   
    @IBOutlet weak var quoteDetailsLabel: UILabel!
    @IBOutlet weak var quoteImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let quote = quote {
            self.title = quote.currency
            quoteDetailsLabel.text = quoteDetails
            
            let svg = URL(string: quote.logoURL!)
            quoteImg.downloadedsvg(from: svg!)
        }
        
    }
    
}



