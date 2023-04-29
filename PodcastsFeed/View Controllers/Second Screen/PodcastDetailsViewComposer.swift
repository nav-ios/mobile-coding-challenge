//
//  PodcastDetailsViewComposer.swift
//  PodcastsFeed
//
//  Created by Nav on 29/04/23.
//

import Foundation

class PodcastDetailsViewComposer{
    static func composeDetailsViewWith(model: Podcast, imageLoader: ImageLoader){
        let bundle = Bundle(identifier: "com.heyhub.PodcastsFeed")
        let storyBoard = UIStoryboard(name: "Podcast", bundle: bundle)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "PodcastDetailViewController") as! PodcastDetailViewController
        detailsVC.imageLoader = imageLoader
        detailsVC.model = model
        let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        navigationController?.pushViewController(detailsVC, animated: true)
        
    }
}
