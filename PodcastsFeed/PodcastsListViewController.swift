//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit



public protocol ImageLoader{
    
    func loadImageData(from url: URL, completion: (Result<Data, Error>) -> Void)
}
class PodcastsListViewController: UITableViewController{
    private var podcastLoader: PodcastLoaderViewController?
    private var imageLoader: ImageLoader?
    var arrayTable = [PodcastCellController](){
        didSet{
            tableView.reloadData()
        }
    }
    
    convenience init(podcastLoader: PodcastLoaderViewController){
       self.init()
        self.podcastLoader = podcastLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = podcastLoader?.view
      
        podcastLoader?.load()
        refreshControl?.beginRefreshing()
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTable.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
        
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PodcastCellController{
        arrayTable[indexPath.row]
    }
}
