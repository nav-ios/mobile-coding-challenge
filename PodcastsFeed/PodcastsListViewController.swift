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
    var arrayTable = [Podcast](){
        didSet{
            tableView.reloadData()
        }
    }
    convenience init(podcastLoader: PodcastLoader, imageLoader: ImageLoader){
       self.init()
       self.podcastLoader = PodcastLoaderViewController(podcastLoader: podcastLoader)
        self.imageLoader = imageLoader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = podcastLoader?.view
        podcastLoader?.onLoad = { arrayPodcasts in
            self.arrayTable = arrayPodcasts
        }
        podcastLoader?.load()
        refreshControl?.beginRefreshing()
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTable.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PodcastCell()
        let model = arrayTable[indexPath.row]
        cell.labelTitle.text = model.title
        cell.labelDescription.text = model.description
        imageLoader?.loadImageData(from: model.thumbnailURL){ result in
            switch result{
            case let .success(data):
                cell.imageThumnail.image = UIImage(data: data)
            case .failure(_):
                cell.imageThumnail.image = UIImage(named: "questionmark.app.fill")
            }
        }
        return cell
    }
}
