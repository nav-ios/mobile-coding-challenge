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
        cacheStore.favouriteAction(podcastID){ result in
            completion(.success(true))
        }
    }
    func isFavourite(podcastID: String, completion: @escaping (Bool) -> Void){
        cacheStore.checkForFavourite(podcastID) { result in
            switch result{
            case let .success(isFav):
                completion(isFav)
            case .failure:
                completion(false)
            }
            
        }
    }
}

enum CacheStoreResult{
    case success(Bool)
    case failure
}

class CacheStore{
    var arrayCompletionCheckForFavourite = [(CacheStoreResult) -> Void]()
    var arrayCompletionFavouriteAction = [(CacheStoreResult) -> Void]()
    var recievedCallCount = 0
    
    func checkForFavourite(_ id: String, completion: @escaping (CacheStoreResult) -> Void){
        recievedCallCount += 1
        arrayCompletionCheckForFavourite.append(completion)
    }
    
    func favouriteAction(_ id: String, completion: @escaping (CacheStoreResult) -> Void){
        arrayCompletionFavouriteAction.append(completion)
    }
    
    func completefavouriteCheckWith(message: Bool, at index: Int = 0){
        arrayCompletionCheckForFavourite[index](.success(message))
        
    }
    func completeFavouriteAction(error: Error?, message: Bool?, at index: Int = 0){
        arrayCompletionFavouriteAction[index](.success(true))
    }
    
}

final class PodcastCacheTests: XCTestCase {

    
    func test_init_doesnotMessageStoreOnCreation(){
        let (_, store) = makeSUT()
        XCTAssertEqual(store.recievedCallCount, 0)
    }
    
    func test_isFavourite_callsStore(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone 15 Podcast", description: "iPhone 15 Launch event")
        sut.isFavourite(podcastID: podcast.id){_ in}
        XCTAssertEqual(store.recievedCallCount, 1)
    }
    
    func test_isFavourite_returnsFalse(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone 15 Podcast", description: "iPhone 15 Launch event")
        let exp = expectation(description: "Wait for store")
        sut.isFavourite(podcastID: podcast.id) { result in
            switch result{
            case true:
                XCTFail("Expected false")
            case false:
                break
            }
            exp.fulfill()
        }
        store.completefavouriteCheckWith(message: false)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_isFavourite_returnsTrue(){
        let (sut, store) = makeSUT()
        let podcast = makePodcast(title: "iPhone 15 Podcast", description: "iPhone 15 Launch event")
        let exp = expectation(description: "Wait for store")

        sut.isFavourite(podcastID: podcast.id) { result in
            switch result{
            case true:
                break
            case false:
                XCTFail("Expected true")
            }
            exp.fulfill()
        }
        store.completefavouriteCheckWith(message: true)
        wait(for: [exp], timeout: 1.0)

    }
    
    
    
    
    
    
    
    
    //    func test_addToFavourite_completesSuccesfully(){
//        let (sut, store) = makeSUT()
//        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
//        let exp = expectation(description: "Wait for store")
//        sut.isFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case let .success(isSaved):
//                XCTAssertFalse(isSaved)
//            case .failure(_):
//                XCTFail("Expected success got failure")
//            }
//            exp.fulfill()
//        }
//        store.completeWith(error: nil, message: false)
//        wait(for: [exp], timeout: 1.0)
//
//    }
//
//
//    func test_save_failsOnStoreFailingWithError(){
//        let (sut, store) = makeSUT()
//        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
//        let exp = expectation(description: "Wait for store")
//        sut.isFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case .success(_):
//                XCTFail("Expected failure got success")
//            case .failure(let error):
//                XCTAssertNotNil(error)
//            }
//            exp.fulfill()
//        }
//
//        store.completeWith(error: anyError(), message: nil)
//        wait(for: [exp], timeout: 1.0)
//    }
//
//    func test_addToFavourite_succeedsSuccesfulyWhenPodcastIsNotAlreadyFavourite(){
//        let (sut, store) = makeSUT()
//        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
//        let exp = expectation(description: "Wait for store")
//        sut.addToFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case let .success(isSaved):
//                XCTAssertTrue(isSaved)
//            case .failure(_):
//                XCTFail("Expected success got failure")
//            }
//            exp.fulfill()
//        }
//
//        store.completeWith(error: nil, message: true)
//        wait(for: [exp], timeout: 1.0)
//    }
//
//    func test_addToFavourite_podcastIsRemovedFromFavourite(){
//        let (sut, store) = makeSUT()
//        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
//        let exp = expectation(description: "Wait for store")
//        sut.addToFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case let .success(isSaved):
//                XCTAssertTrue(isSaved)
//            case .failure(_):
//                XCTFail("Expected success got failure")
//            }
//            exp.fulfill()
//        }
//        store.completeWith(error: nil, message: false)
//
//        wait(for: [exp], timeout: 1.0)
//    }
//
//    func test_addToFavourite_addsSucessfuly(){
//        let (sut, store) = makeSUT()
//        let podcast = makePodcast(title: "iPhone Podcast", description: "Tim Cook delivers WWDC 2023")
//        let exp = expectation(description: "Wait for store")
//        exp.expectedFulfillmentCount = 2
//        sut.addToFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case let .success(isSaved):
//                XCTAssertTrue(isSaved)
//            case .failure(_):
//                XCTFail("Expected success got failure")
//            }
//            exp.fulfill()
//        }
//        store.completeFavouriteAction(error: nil, message: true)
//
//        sut.isFavourite(podcastID: podcast.id) { result in
//            switch result{
//            case .success(_):
//                XCTFail("Expected failure got success")
//            case .failure(let error):
//                XCTAssertNotNil(error)
//            }
//            exp.fulfill()
//        }
//        store.completeWith(error: nil, message: true)
//
//        wait(for: [exp], timeout: 1.0)
//    }
//
    
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
