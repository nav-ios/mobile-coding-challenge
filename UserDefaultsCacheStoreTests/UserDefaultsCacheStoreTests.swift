//
//  UserDefaultsCacheStoreTests.swift
//  UserDefaultsCacheStoreTests
//
//  Created by Nav on 30/04/23.
//

import XCTest
@testable import PodcastsFeed

final class UserDefaultsCacheStoreTests: XCTestCase {


    func test_checkForFavourite_resultsFalseWhenPodcastIsNotFavourited(){
        let sut = UserDefaultsCacheStore()
        let podcastID = makePodcastID()
        sut.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertFalse(isFav)
            case .failure:
                XCTFail("Expected success with false but got failure")
            }
        }
    }
    
    func test_checkForFavourite_returnsTrueAfterPodcastIsFavourited(){
        let sut = UserDefaultsCacheStore()
        let podcastID = makePodcastID()
        sut.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertFalse(isFav)
            case .failure:
                XCTFail("Expected success with false but got failure")
            }
        }
        
        sut.favouriteAction(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertTrue(isFav)
            case .failure:
                XCTFail("Expected success with true but got failure")
            }
        }
        
        sut.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertTrue(isFav)
            case .failure:
                XCTFail("Expected success with true but got failure")
            }
        }
    }
    func test_checkForFavourite_returnsFalseAfterPodcastIsFavouritedAndThenRemoved(){
        let sut = UserDefaultsCacheStore()
        let podcastID = makePodcastID()
        sut.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertFalse(isFav)
            case .failure:
                XCTFail("Expected success with false but got failure")
            }
        }
        
        sut.favouriteAction(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertTrue(isFav)
            case .failure:
                XCTFail("Expected success with true but got failure")
            }
        }
        
        sut.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertTrue(isFav)
            case .failure:
                XCTFail("Expected success with true but got failure")
            }
        }
        
        sut.favouriteAction(podcastID) { result in
            switch result{
            case let .success(isFav):
                XCTAssertFalse(isFav)
            case .failure:
                XCTFail("Expected success with false but got failure")
            }
        }
    }
    
    
    
    private func makePodcastID() -> String{
        return UUID().uuidString
    }
    
    override class func tearDown() {
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
    }
}
