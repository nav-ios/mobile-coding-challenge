//
//  PodcastFeedTests.swift
//  PodcastFeedTests
//
//  Created by Nav on 26/04/23.
//

import XCTest
@testable import PodcastsFeed
import PodcastAPI
import SwiftyJSON

final class PodcastFeedEndToEndAPITests: XCTestCase {

    
    func test_load_succeedsWithPodcastObjects(){
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Wait for client to finish request")
        sut.load { result in
            switch result{
            case let .success(arrayPodcast):
                XCTAssertFalse(arrayPodcast.isEmpty)
                XCTAssertFalse(arrayPodcast[0].title.isEmpty, "Expected non empty title")
                XCTAssertFalse(arrayPodcast[0].publisher.isEmpty, "Expected non empty publisher")
                XCTAssertFalse(arrayPodcast[1].title.isEmpty, "Expected non empty second title")
                XCTAssertFalse(arrayPodcast[1].publisher.isEmpty, "Expected non empty second publisher")

            case let .failure(error):
                XCTFail("Expected succesfull result, but got \(error) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    private func makeSUT() -> (PodcastLoaderAPI, RemotePodcastClient){
        let client = RemotePodcastClient()
        let sut = PodcastLoaderAPI(client: client)
        return (sut, client)
    }

}
