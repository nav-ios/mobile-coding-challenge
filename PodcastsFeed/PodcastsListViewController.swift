//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastsListViewController: UITableViewController{
    private var loader: PodcastLoader?
    var arrayTable = [Podcast](){
        didSet{
            tableView.reloadData()
        }
    }
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
        return cell
    }
}
