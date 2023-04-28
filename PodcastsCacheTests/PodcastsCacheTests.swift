//
//  PodcastCacheTests.swift
//  PodcastCacheTests
//
//  Created by Nav on 28/04/23.
//

import XCTest
@testable import PodcastsFeed

public enum PodcastCacheResult{
    case success(Bool)
    case failure(Error)
}

class PodcastCache{
    
    private var cacheStore: CacheStore
    init(cacheStore: CacheStore) {
        self.cacheStore = cacheStore
    }
    
    func addToFavourite(podcastID: String, completion: (PodcastCacheResult) -> Void){
        
    }
    func isFavourite(podcastID: String, completion: @escaping (PodcastCacheResult) -> Void){
        cacheStore.checkForFavourite(podcastID){ result in
            switch result{
            case true:
                completion(.success(true))
            case false:
                completion(.success(false))
            }
        }
    }
}

class CacheStore{
    var arrayCompletion = [(Bool) -> Void]()
    func checkForFavourite(_ id: String, completion: @escaping (Bool) -> Void){
        arrayCompletion.append(completion)
    }
    
    func completeWith(error: Error?, message: Bool, at index: Int = 0){
        if error == nil{
            arrayCompletion[index](true)
        }else{
            arrayCompletion[index](false)
        }
    }
    
}

final class PodcastCacheTests: XCTestCase {
    func test_addToFavourite_completesSuccesfully(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
        let exp = expectation(description: "Wait for store")
        sut.isFavourite(podcastID: podcast.id) { result in
            switch result{
            case let .success(isSaved):
                XCTAssertFalse(isSaved)
            case .failure(_):
                XCTFail("Expected success got failure")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        store.completeWith(error: nil, message: false)
        
    }
    
    func makeSUT() -> (PodcastCache, CacheStore){
        let cacheStore = CacheStore()
        let sut = PodcastCache(cacheStore: cacheStore)
        return (sut, cacheStore)
    }
    func makePodcast(title: String, description: String, isFavourite: Bool = false) -> Podcast{
        let id = UUID().uuidString
        if isFavourite{
            UserDefaults.standard.set(true, forKey: id)
        }
           return Podcast(title: title, description: description, id: id, imageURL: anyURL(), thumbnailURL: anyURL(), publisher: "Some publisher")
        }

    private func anyURL() -> URL{
        URL(string: "http://any-podcast-url.com")!
    }
}
