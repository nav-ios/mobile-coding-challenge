//
//  RemotePodcastClient.swift
//  PodcastFeed
//
//  Created by Nav on 26/04/23.
//

import Foundation
import PodcastAPI

public class RemotePodcastClient: PodcastClient{
    
    public func getPodcasts(completion: @escaping (PodcastClientResult) -> Void) {
        let apiKey = ""
        let client = PodcastAPI.Client(apiKey: apiKey)
        var parameters: [String: String] = [:]
        parameters["genre_id"] = "93"
        parameters["page"] = "2"
        parameters["region"] = "us"
        parameters["sort"] = "listen_score"
        parameters["safe_mode"] = "0"

        client.search(parameters: parameters) { response in
            if let error = response.error {
                switch (error) {
                case PodcastApiError.apiConnectionError:
                    print("Can't connect to Listen API server")
                case PodcastApiError.authenticationError:
                    print("wrong api key")
                default:
                    print("unknown error")
                }
            } else {
                if let data = response.toJson() {
                    completion(.success(data))
                }
                
            }
        }
    }
}
