//
//  PodcastDetailsViewComposer.swift
//  PodcastsFeed
//
//  Created by Nav on 29/04/23.
//

import Foundation
import UIKit
class PodcastDetailsViewComposer{
    static func composeDetailsViewWith(model: Podcast, imageLoader: ImageLoader, for navigationController: UINavigationController){
        let bundle = Bundle(identifier: "com.heyhub.PodcastsFeed")
        let storyBoard = UIStoryboard(name: "Podcast", bundle: bundle)
        let podcastCache = PodcastCache(cacheStore: UserDefaultsCacheStore())

        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "PodcastDetailViewController") as! PodcastDetailViewController
        detailsVC.imageLoader = imageLoader
        detailsVC.model = model
        detailsVC.podcastCache = podcastCache
        navigationController.pushViewController(detailsVC, animated: true)
        
    }
}
