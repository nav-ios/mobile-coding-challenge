//
//  ViewController.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastsListViewController: UIViewController{
    private var loader: PodcastLoader?
    
   convenience init(loader: PodcastLoader){
       self.init()
       self.loader = loader
    }
    
    override func viewDidLoad() {
        loader?.load(completion: { result in
            
        })
    }
}
