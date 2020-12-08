//
//  QuoteViewController.swift
//  CryptoConverter
//
//  Created by Admin on 10/19/20.
//  Copyright © 2020 Riza. All rights reserved.
//

import UIKit
import SkeletonView
import Toast_Swift


class QuotesViewController: UITableViewController, SkeletonTableViewDataSource {
    
    let quoteProvider = QuoteProvider()
    var quotes = [Quote]()
    let refresher = UIRefreshControl()
    var timer: Timer?
    var selectQuoteMode: Int?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        setupRefresher()
        makeToast()
        
        loadQuotes()
     
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: C.updateNotificationName), object: nil)
        
    }
//MARK: - Data Loading Methods
    
    func loadQuotes() {
        if currentReachabilityStatus == .notReachable {
            self.tableView.makeToast("No internet Connection", duration: 3.0, position: .center)
        } else {
            quotes = getData()
        }
    }
    
    func getData() -> [Quote]{
        quoteProvider.performRequest { quotes in
            DispatchQueue.main.async {
                self.quotes = quotes
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
                self.tableView.reloadData()
            }
        }
        return quotes
    }
    
//MARK: - UI updating Methods
    
    @objc func updateTimer() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.updateNotificationName), object: getData(), userInfo: nil)
    }

    @objc func updateData(notification: Notification) {
        self.updateQuotes(quotes: notification.object as! [Quote])
    }
    
    func updateQuotes(quotes: [Quote]) {
        self.quotes = quotes
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadQuotes()
        tableView.stopSkeletonAnimation()
        tableView.hideSkeleton()
    }
    
    func setupRefresher() {
        tableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        quoteProvider.performRequest { quotes in
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
                self.quotes = quotes
                self.tableView.reloadData()
            }
        }
    }
    
    func makeToast() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
        } else {
            print("First launch")
            self.tableView.makeToast("Welcome to CryptoConverter", duration: 3.0, position: .center)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
    }
    
//MARK: - Table View Delegates and Data Source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return C.reusableCellIdentifier
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quote = quotes[indexPath.row]
        dismiss(animated: true)
        guard let unwrappedSelectQuoteMode = selectQuoteMode else {
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.convertNotificationName), object: quote.name, userInfo: ["SelectQuoteMode" : unwrappedSelectQuoteMode ])
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: C.reusableCellIdentifier, for: indexPath) as? QuoteCell {
            let quote = quotes[indexPath.row]
            let rank = indexPath.row + 1
            cell.configure(with: quote, name: quote.name, rank: rank)
            return cell
        }
        return QuoteCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if selectQuoteMode != nil {
            dismiss(animated: true)
        }
        
        if segue.identifier == C.segueIdentifier {
            
            let destinationVC = segue.destination as? QuoteDetailsViewController
            let indexPath = tableView.indexPathForSelectedRow
            
            destinationVC?.quote = quotes[indexPath!.row]
            destinationVC?.quoteDetails = quotes[indexPath!.row].description
        
        }
    }
    
}

