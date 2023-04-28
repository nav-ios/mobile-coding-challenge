//
//  PodcastCache.swift
//  PodcastsFeed
//
//  Created by Nav on 28/04/23.
//

import Foundation
enum PodcastCacheResult{
    case success(Bool)
    case failure(Error)
}
protocol PodcastCache{
    
    func saveToCache(podcastID: String, completion: (PodcastCacheResult) -> Void)
    func isCached(podcastID: String, completion: @escaping (PodcastCacheResult) -> Void)
}
