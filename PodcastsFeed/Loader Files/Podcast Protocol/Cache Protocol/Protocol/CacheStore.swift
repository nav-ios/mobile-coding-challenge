//
//  CacheStore.swift
//  PodcastsFeed
//
//  Created by Nav on 29/04/23.
//

import Foundation
  

protocol CacheStore{
    typealias Result = Swift.Result<Bool, Error>

    func checkForFavourite(_ id: String, completion: @escaping (Result) -> Void)
    func favouriteAction(_ id: String, completion: @escaping (Result) -> Void)
}
