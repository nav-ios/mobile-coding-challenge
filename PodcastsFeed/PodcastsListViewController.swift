//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastsListViewController: UITableViewController{
    private var loader: PodcastLoader?
    
   convenience init(loader: PodcastLoader){
       self.init()
       self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        
        refreshControl?.beginRefreshing()
        loader?.load(completion: { [weak self] result in
            self?.refreshControl?.endRefreshing()
        })
    }
}
