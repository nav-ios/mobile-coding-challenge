//
//  PodcastDetailViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastDetailViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var imagePodcast: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    var model: Podcast!
    var imageLoader: ImageLoader?
    var podcastCache: PodcastCache?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewObjects()
        checkFavourite()

        labelTitle.text = model?.title
        labelAuthor.text = model?.publisher
        labelDescription.attributedText = model?.description.htmlAttributedString()
        guard let imageURL = model?.imageURL else {return}
        imageLoader?.loadImageData(from: imageURL) { [weak self] result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imagePodcast.image = UIImage(data: data)
                }
            case .failure(_):
                
                self?.imagePodcast.image = UIImage(systemName: "questionmark.app.fill")
            }
        }
    }
    
    private func setupViewObjects(){
        imagePodcast.layer.cornerRadius = 25
        buttonFavourite.layer.cornerRadius = 10
    }
    
    @IBAction func actionFavourite(_ sender: UIButton) {
        podcastCache?.favouriteAction(podcastID: model.id, completion: { [weak self] result in
            switch result{
            case let .success(favResult):
                if favResult{
                    self?.buttonFavourite.setTitle("Favourited", for: .normal)
                }else{
                    self?.buttonFavourite.setTitle("Favourite", for: .normal)
                }
            case .failure(_):
                break
            }
        })
    }
    
    private func checkFavourite(){
        podcastCache?.isFavourite(podcastID: model.id, completion: { [weak self] result in
            switch result{
            case true:
                self?.buttonFavourite.setTitle("Favourited", for: .normal)
            case false:
                self?.buttonFavourite.setTitle("Favourite", for: .normal)
            }
        })
    }

}
