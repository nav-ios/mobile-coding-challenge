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
        _ = PodcastListsComposer.composeWith(podcastLoader: loader, imageLoader: loader)
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
        let podcast1 = makePodcast(title: "Some title", description: "Some description")
        let podcast2 = makePodcast(title: "Some title", description: "Some description 2")
        loader.completeLoading([podcast1, podcast2])
        XCTAssertEqual(sut.numberOfLoadedCells(), 2)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func test_viewDidLoad_showsCellsWithCorrectDataOnSuccesfulCompletion(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfLoadedCells(), 0)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        let podcast1 = makePodcast(title: "Title 1", description: "Description 1")
        let podcast2 = makePodcast(title: "Title 2", description: "Description 2")
        
        loader.completeLoading([podcast1, podcast2])
        XCTAssertEqual(sut.numberOfLoadedCells(), 2)
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
        
        let cell1 = sut.podcastView(at: 0)
        let cell2 = sut.podcastView(at: 1)
        
        XCTAssertEqual(cell1?.title, podcast1.title)
        XCTAssertEqual(cell1?.descriptionString, podcast1.description)
        
        XCTAssertEqual(cell2?.title, podcast2.title)
        XCTAssertEqual(cell2?.descriptionString, podcast2.description)
    }
    
    func test_viewDidLoad_invokesImageLoaderOncellCreation(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let podcast1 = makePodcast(title: "Title 1", description: "Description 1")
        let podcast2 = makePodcast(title: "Title 2", description: "Description 2")
        loader.completeLoading([podcast1, podcast2])

        XCTAssertEqual(sut.numberOfLoadedCells(), 2)
        
        sut.makeCellVisible(at: 0)
        sut.makeCellVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [podcast1.thumbnailURL, podcast2.thumbnailURL])
    }
    
    func makeSUT() -> (PodcastsListViewController, LoaderSpy){
        let loader = LoaderSpy()
        let sut = PodcastListsComposer.composeWith(podcastLoader: loader, imageLoader: loader)
        return (sut, loader)
    }
    
    func makePodcast(title: String, description: String) -> Podcast{
        Podcast(title: title, description: description, id: UUID().uuidString, imageURL: anyURL(), thumbnailURL: anyURL(), publisher: "Some publisher")
    }
    
    private func anyURL() -> URL{
        URL(string: "http://any-podcast-url.com")!
    }
    
    class LoaderSpy: PodcastLoader, ImageLoader{
       
        func loadImageData(from url: URL, completion: (Result<Data, Error>) -> Void) {
            loadedImageURLs.append(url)
        }
        
         var loadedImageURLs = [URL]()
    
        
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
    
    func makeCellVisible(at row: Int){
        podcastView(at: row)
    }
    
    func podcastView(at row: Int) -> PodcastCell?{
        let ds = tableView.dataSource
        let indexPath = IndexPath(row: row, section: 0)
        return ds?.tableView(tableView, cellForRowAt: indexPath) as? PodcastCell
    }
}

private extension PodcastCell{
    var title: String?{
        return labelTitle.text
    }
    var descriptionString: String?{
        return labelDescription.text
    }
    var isFavouritHidden: Bool{
        return !labelFavorite.isHidden
    }
}
