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
    
    func addToFavourite(podcastID: String, completion: @escaping (PodcastCacheResult) -> Void){
        cacheStore.addToFavourite(podcastID){ result in
            completion(.success(true))
        }
    }
    func isFavourite(podcastID: String, completion: @escaping (PodcastCacheResult) -> Void){
        cacheStore.checkForFavourite(podcastID){ result in
            switch result{
            case let .success(isSaved):
                completion(.success(isSaved))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

enum CacheStoreResult{
    case success(Bool)
    case failure(Error)
}

class CacheStore{
    var arrayCompletion = [(CacheStoreResult) -> Void]()
    
    func checkForFavourite(_ id: String, completion: @escaping (CacheStoreResult) -> Void){
        arrayCompletion.append(completion)
    }
    
    func addToFavourite(_ id: String, completion: @escaping (CacheStoreResult) -> Void){
        arrayCompletion.append(completion)
    }
    func completeWith(error: Error?, message: Bool? = nil, at index: Int = 0){
        if error == nil{
            arrayCompletion[index](.success(message!))
        }else{
            arrayCompletion[index](.failure(error!))
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
        store.completeWith(error: nil, message: false)
        wait(for: [exp], timeout: 1.0)
        
    }
    
    
    func test_save_failsOnStoreFailingWithError(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
        let exp = expectation(description: "Wait for store")
        sut.isFavourite(podcastID: podcast.id) { result in
            switch result{
            case let .success(_):
                XCTFail("Expected failure got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        
        store.completeWith(error: anyError(), message: nil)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_addToFavourite_succeedsSuccesfulyWhenPodcastIsNotAlreadyFavourite(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
        let exp = expectation(description: "Wait for store")
        sut.addToFavourite(podcastID: podcast.id) { result in
            switch result{
            case let .success(isSaved):
                XCTAssertTrue(isSaved)
            case .failure(_):
                XCTFail("Expected success got failure")
            }
            exp.fulfill()
        }
        
        store.completeWith(error: nil, message: true)
        wait(for: [exp], timeout: 1.0)
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

    private func anyError() -> NSError{
        NSError(domain: "Any podcast error", code: 10)
    }
    
    private func anyURL() -> URL{
        URL(string: "http://any-podcast-url.com")!
    }
}
