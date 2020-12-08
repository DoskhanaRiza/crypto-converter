//
//  ConvertViewController.swift
//  CryptoConverter
//
//  Created by Riza on 11/11/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import UIKit
import AVFoundation

class ConvertViewController: UIViewController, UITextFieldDelegate {
   
    var quoteProvider = QuoteProvider()
    var converter: Converter?
    var quotes = [Quote]()
    var player: AVAudioPlayer!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var chooseCurrency: UIButton!
    @IBOutlet weak var choose2ndCurrency: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        amountTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getQuote(notification:)), name: NSNotification.Name(rawValue: C.convertNotificationName), object: nil)
            
    }
    
    @objc func getQuote(notification: Notification) {
        if let data = notification.userInfo as? [String : Int] {
            for (_, number) in data {
                if number == 1 {
                    chooseCurrency.setTitle(notification.object as? String, for: .normal)
                } else {
                    choose2ndCurrency.setTitle(notification.object as? String, for: .normal)
                }
            }
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    func getData() {
        quoteProvider.performRequest { quotes in
            DispatchQueue.main.async {
                self.quotes = quotes
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if chooseCurrency.titleLabel?.text == nil || choose2ndCurrency.titleLabel?.text == nil {
            resultLabel.text = "0.0"
            return true
        } else if chooseCurrency.titleLabel?.text != nil && choose2ndCurrency.titleLabel?.text != nil {
            convert()
            return true
        } else {
            return false
        }
    }
    
    @IBAction func chooseCurrencyTapped(_ sender: UIButton) {
        playSound()
    }
        
    
    @IBAction func choose2ndCurrencyTapped(_ sender: UIButton) {
        playSound()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quotesVC = segue.destination as? QuotesViewController {
            if segue.identifier == C.firstConvertSegueIdentifier {
                quotesVC.selectQuoteMode = 1
            } else if segue.identifier == C.secondConvertSegueIdentifier {
                quotesVC.selectQuoteMode = 2
            }
        }
       
    }
    
    func convert() {
        
        let baseQuote = quotes.filter({quote in quote.name == chooseCurrency.titleLabel?.text})[0]
        converter = Converter(baseQuote: baseQuote)
        //        print(baseQuote)
        
        guard let converter = converter else {
            print("baseQuote not generated")
            return;
        }
        
        guard let amount = Double(amountTextField.text ?? "1") else {
            print("Enter amount for conversion")
            return;
        }
        
        let convertQuote = quotes.filter({quote in quote.name == choose2ndCurrency.titleLabel?.text})[0]
        
        guard let result = converter.convert(convertQuote: convertQuote, amount: Float(amount)) ?? 0.0 else { return }
        let resultAsString = String(format: "%.3f", result)
        resultLabel.text = String(format: "You can buy %@ %@ for %.1f %@", resultAsString, convertQuote.name, amount, baseQuote.name)
        
    }
    
}
