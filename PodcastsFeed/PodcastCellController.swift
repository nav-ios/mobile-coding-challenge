//
//  PodcastCellController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import Foundation
import UIKit

final class PodcastCellController{
    private var imageLoader: ImageLoader?
    private var model: Podcast
    init(imageLoader: ImageLoader, model: Podcast) {
        self.imageLoader = imageLoader
        self.model = model
    }
    
    
    func view() -> UITableViewCell {
        let cell = PodcastCell()
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
