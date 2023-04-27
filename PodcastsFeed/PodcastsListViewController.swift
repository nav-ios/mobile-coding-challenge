//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit



public protocol ImageLoader{
    
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
class PodcastsListViewController: UITableViewController{
    var podcastLoader: PodcastLoaderViewController?
    private var imageLoader: ImageLoader?
    var arrayTable = [PodcastCellController](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
      
        return cellController(forRowAt: indexPath).view(in: tableView)
        
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PodcastCellController{
        arrayTable[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        arrayTable[indexPath.row].releaseCell()
    }
}
