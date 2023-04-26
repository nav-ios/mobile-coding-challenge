//
//  PodcastFeediOSTests.swift
//  PodcastFeediOSTests
//
//  Created by Nav on 26/04/23.
//

import XCTest
import UIKit
@testable import PodcastsFeed


final class PodcastFeediOSTests: XCTestCase {

    func test_init_instanceDoesnotCallPodcastLoaderOnCreation(){
        let loader = LoaderSpy()
        _ = PodcastsListViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_invokesLoader(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_viewDidLoad_showsLoadingIndicator(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
      
    func test_viewDidLoad_hidesLoadingIndicatorWhenLoadCompletes(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        loader.completeLoading([])
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    
    func test_viewDidLoad_showsLoadedItemsOnTableViewOnSuccess(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfLoadedCells(), 0)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        let podcast1 = makePodcast()
        let podcast2 = makePodcast()
        loader.completeLoading([podcast1, podcast2])
        XCTAssertEqual(sut.numberOfLoadedCells(), 2)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    func makeSUT() -> (PodcastsListViewController, LoaderSpy){
        let loader = LoaderSpy()
        let sut = PodcastsListViewController(loader: loader)
        return (sut, loader)
    }
    
    func makePodcast() -> Podcast{
        Podcast(title: "Some title", description: "some description", id: UUID().uuidString, imageURL: anyURL(), thumbnailURL: anyURL(), publisher: "Some publisher")
    }
    
    private func anyURL() -> URL{
        URL(string: "http://any-podcast-url.com")!
    }
    
    class LoaderSpy: PodcastLoader{
        var arrayCompletions = [(PodcastLoaderResult) -> Void]()
        
        func load(completion: @escaping (PodcastLoaderResult) -> Void) {
            loadCallCount += 1
            arrayCompletions.append(completion)
        }
        
        func completeLoading(_ podcasts: [Podcast], at index: Int = 0){
            arrayCompletions[index](.success(podcasts))
        }
        
        var loadCallCount = 0
        
    }
    

   
}
private extension PodcastsListViewController{
    func numberOfLoadedCells() -> Int{
        tableView.numberOfRows(inSection: 0)
    }
}
