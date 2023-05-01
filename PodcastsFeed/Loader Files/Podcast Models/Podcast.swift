//
//  Podcast.swift
//  PodcastsFeed
//
//  Created by Nav on 01/05/23.
//

import Foundation
public struct Podcast {
    public init(title: String, description: String, id: String, imageURL: URL, thumbnailURL: URL, publisher: String) {
        self.title = title
        self.description = description
        self.id = id
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
        self.publisher = publisher
    }
    
    public var title: String
    public var description: String
    public var id: String
    public var imageURL: URL
    public var thumbnailURL: URL
    public var publisher: String
}
