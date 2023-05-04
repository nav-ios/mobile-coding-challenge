//
//  PodcastClient.swift
//  PodcastFeed
//
//  Created by Nav on 26/04/23.
//

import Foundation
import PodcastAPI
import SwiftyJSON



public protocol PodcastClient{
    typealias Result = Swift.Result<JSON, PodcastApiError>

    func getPodcasts(completion: @escaping (Result) -> Void)
}
