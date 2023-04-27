//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

public protocol ImageLoader{
    func loadImageData(from url: URL)
}
class PodcastsListViewController: UITableViewController{
    private var podcastLoader: PodcastLoader?
    private var imageLoader: ImageLoader?
    var arrayTable = [Podcast](){
        didSet{
            tableView.reloadData()
        }
    }
    convenience init(podcastLoader: PodcastLoader, imageLoader: ImageLoader){
       self.init()
       self.podcastLoader = podcastLoader
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        
        refreshControl?.beginRefreshing()
        podcastLoader?.load(completion: { [weak self] result in
            self?.refreshControl?.endRefreshing()
            switch result{
            case let .success(arrayPodcasts):
                self?.arrayTable = arrayPodcasts
            case .failure(_):
                break
            }
        })
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTable.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PodcastCell()
        let model = arrayTable[indexPath.row]
        cell.labelTitle.text = model.title
        cell.labelDescription.text = model.description
        imageLoader?.loadImageData(from: model.thumbnailURL)
        return cell
    }
}
