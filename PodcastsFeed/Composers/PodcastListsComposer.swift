//
//  PodcastListsComposer.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import Foundation
public class PodcastListsComposer{
    
    static func composeWith(podcastLoader: PodcastLoader, imageLoader: ImageLoader) -> PodcastsListViewController{
       let podcastLoader = PodcastLoaderViewController(podcastLoader: podcastLoader)
        let podcastController = PodcastsListViewController(podcastLoader: podcastLoader)
        podcastLoader.onLoad = { [weak podcastController] arrayPodcasts in
            podcastController?.arrayTable = arrayPodcasts.map{ podcast in
                PodcastCellController(imageLoader: imageLoader, model: podcast)
            }
        }
        return podcastController
    }
}
