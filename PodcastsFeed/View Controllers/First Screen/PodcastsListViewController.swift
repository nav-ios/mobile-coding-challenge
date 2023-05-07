//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastsListViewController: UITableViewController{
    var podcastLoader: PodcastLoaderViewController?
    private var imageLoader = URLSessionImageLoader()
    var arrayTable = [PodcastCellController](){
        didSet{
                self.tableView.reloadData()
                self.tableView.tableFooterView = self.loadMoreView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = podcastLoader?.view
        podcastLoader?.load()
        refreshControl?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTable.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PodcastCellController {
        arrayTable[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        arrayTable[indexPath.row].releaseCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PodcastDetailsViewComposer.composeDetailsViewWith(model: arrayTable[indexPath.row].model, imageLoader: imageLoader, for: self.navigationController!)
    }

}
