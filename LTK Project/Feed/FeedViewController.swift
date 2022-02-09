//
//  ViewController.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import UIKit
import SystemConfiguration

class FeedViewController: UITableViewController {
    
    private let networkService = Network()
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    private let reachable = Reachability()!
    private var feeds = [JSON.Item.Feed]()
    private var profileId: String?
    private var productId: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setReachabilityNotifier()
    }
    
    // MARK: - Helpers
    
    func loadFeed() {
        networkService.getFeed { feed, error  in
            guard feed != nil && error == nil else {
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            guard let feedResult = feed?.results,
                  feedResult.count > 0 else {
                      DispatchQueue.main.async {
                          self.feeds.removeAll()
                          self.tableView.reloadData()
                      }
                      return
                  }
            
            self.feeds = feedResult
            DispatchQueue.main.async {
                self.tableView.backgroundView = UIView()
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        navigationItem.title = "LTK"
        navigationController?.navigationBar.tintColor = .black
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Tableview Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let feedCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedTableViewCell {
            feedCell.configureCell(with: feeds[indexPath.row])
            return feedCell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileId = feeds[indexPath.row].profileId
        productId = feeds[indexPath.row].productId.first
        performSegue(withIdentifier: "feedDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              identifier == "feedDetails",
              let viewController = segue.destination as? FeedDetailViewController
        else { return }
        
        viewController.selectedProfileId = profileId
        viewController.selectedProductId = productId
    }
    
}

extension FeedViewController {
    
    // MARK: - Network Listener | Reachability
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            self.presentAlert(message: "Please connect to internet to view feed", title: "No Connection")
        }
    }
    
    private func setReachabilityNotifier () {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachable)
        do {
            try reachable.startNotifier()
        }
        catch {
            print("could not start reachability notifier")
        }
    }
    
    private func checkReachable() {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)){
            if flags.contains(.isWWAN) {
                return
            }
        }
        else if (!isNetworkReachable(with: flags)) {
            self.presentAlert(message:"Please connect to internet to view feed", title: "No Connection")
            return
        }
    }
    
}
