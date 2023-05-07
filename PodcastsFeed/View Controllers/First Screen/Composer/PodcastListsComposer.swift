//
//  PodcastListsComposer.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import Foundation
import UIKit
public class PodcastListsComposer{
    /// Use to create an instance of PodcastsListViewController with all the dependencies that it needs.
    /// It returns PodcastsListViewController wrapped in a UINavigationController at its root.
    /// You can access the root view controller of this UINavigationController if you need to acess the PodcastsListViewController instance directly
    static func composeWith(podcastLoader: PodcastLoader, imageLoader: ImageLoader) -> UINavigationController{
       let podcastLoader = PodcastLoaderViewController(podcastLoader: DispatchesOnMainQueueDecorator(podcastLoader: podcastLoader))
        let bundle = Bundle(identifier: "com.heyhub.PodcastsFeed")
        let storyBoard = UIStoryboard(name: "Podcast", bundle: bundle)
        
        let podcastController = storyBoard.instantiateInitialViewController() as! PodcastsListViewController
        podcastController.podcastLoader = podcastLoader
        podcastLoader.onLoad = transformPodcastsToCellControllers(for: podcastController, imageLoader: imageLoader)
        let navigationController = UINavigationController(rootViewController: podcastController)

        return navigationController
    }
    
    static func transformPodcastsToCellControllers(for podcastController: PodcastsListViewController, imageLoader: ImageLoader) -> ([Podcast]) -> Void {
        return { [weak podcastController] arrayPodcasts in
            podcastController?.arrayTable += arrayPodcasts.map{ podcast in
                PodcastCellController(imageLoader: imageLoader, model: podcast)
            }
        }
    }
    
    private final class DispatchesOnMainQueueDecorator: PodcastLoader{
        private let podcastLoader: PodcastLoader
        init(podcastLoader: PodcastLoader) {
            self.podcastLoader = podcastLoader
        }
        
        func load(completion: @escaping (PodcastLoaderResult) -> Void) {
            podcastLoader.load { result in
                if Thread.isMainThread{
                    completion(result)
                }else{
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
        }
        
    }
}
