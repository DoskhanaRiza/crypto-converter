//
//  AboutViewController.swift
//  CryptoConverter
//
//  Created by Riza on 11/11/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let info = Info()
    
    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoImage.image = UIImage(named: "ProfilePhoto")
        infoLabel.text = info.description

    }

}
