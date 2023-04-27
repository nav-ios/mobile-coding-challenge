//
//  URLSessionImageLoader.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import Foundation
class URLSessionImageLoader: ImageLoader{
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(data!))
        }.resume()
    }
    
    
}
