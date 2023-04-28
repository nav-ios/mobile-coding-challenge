//
//  PodcastListsComposer.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import Foundation
import UIKit
public class PodcastListsComposer{
    
    static func composeWith(podcastLoader: PodcastLoader, imageLoader: ImageLoader) -> UINavigationController{
       let podcastLoader = PodcastLoaderViewController(podcastLoader: podcastLoader)
        let bundle = Bundle(identifier: "com.heyhub.PodcastsFeed")
        let storyBoard = UIStoryboard(name: "Podcast", bundle: bundle)
        
        let podcastController = storyBoard.instantiateInitialViewController() as! PodcastsListViewController
        podcastController.podcastLoader = podcastLoader
        podcastLoader.onLoad = { [weak podcastController] arrayPodcasts in
            podcastController?.arrayTable = arrayPodcasts.map{ podcast in
                PodcastCellController(imageLoader: imageLoader, model: podcast)
            }
        }
        let navigationController = UINavigationController(rootViewController: podcastController)

        return navigationController
    }
}
