//
//  PodcastDetailsViewTests.swift
//  PodcastDetailsViewTests
//
//  Created by Nav on 27/04/23.
//

import XCTest
@testable import PodcastsFeed

final class PodcastDetailsViewTests: XCTestCase {
    
    func test_viewDidLoad_doesnotDisplayFavouritedTitleOnButton(){
        let podcast = makePodcast(title: "Some Podcast", description: "Some description", isFavourite: false)
        let (sut, _, _) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isPodcastFavourite, false)
        
    }
    
    
    func test_viewDidLoad_checksValuesOnLabel(){
        let podcast = makePodcast(title: "Some Podcast", description: "Some description", isFavourite: false)
        let (sut, _, _) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isPodcastFavourite, false)
        XCTAssertEqual(sut.titlePodcast, podcast.title)
        XCTAssertEqual(sut.descriptionPodcast, podcast.description)

        
    }
    
    
    func test_loadsImageSuccessfullyFromBackend(){
        let podcast = makePodcast(title: "Star wars", description: "Star wars podcast")
        let (sut, loader, _) = makeSUT(with: podcast)
        let imageStarWars = UIImage(named: "starwars.png")
        sut.loadViewIfNeeded()
        let exp = expectation(description: "wait for image to complete")
        sut.imageLoader?.loadImageData(from: podcast.imageURL){_ in }
        loader.completeImageLoadingWith(data: imageStarWars!.pngData()!)
        DispatchQueue.main.async {
            XCTAssertEqual(sut.imagePodcastData, imageStarWars?.pngData())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_loader_showsDefaultFallbackImageOnImageLoaderCompletingWithError(){
        let podcast = makePodcast(title: "Star wars", description: "Star wars podcast")
        let (sut, loader, _) = makeSUT(with: podcast)
        let defaultImage = UIImage(systemName: "questionmark.app.fill")
        sut.loadViewIfNeeded()
        let exp = expectation(description: "wait for image to complete")
        sut.imageLoader?.loadImageData(from: podcast.imageURL){_ in }
        loader.completeImageLoadingWith(error: NSError(domain: "Failed to load image", code: 99))
        DispatchQueue.main.async {
            XCTAssertEqual(sut.imagePodcastData, defaultImage!.pngData())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_viewDidLoad_showsFavouriteTitleOnButtonForNotFavouritePodcast(){
        let podcast = makePodcast(title: "Star wars", description: "Star wars podcast", isFavourite: false)
        let (sut, _, cache) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        let exp = expectation(description: "wait for completion")
        DispatchQueue.main.async {
            XCTAssertEqual(sut.isPodcastFavourite, false)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        cache.completeCheckForFavouriteWith(result: .success(false))
    }
    
    
    func test_viewDidLoad_showsFavouritedTitleOnButtonAfterAPodcastIsAddedToFavourite(){
        let podcast = makePodcast(title: "Star wars", description: "Star wars podcast", isFavourite: false)
        let (sut, _, cache) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        let exp = expectation(description: "wait for completion")
               
        sut.buttonFavourite.sendActions(for: .touchUpInside)
        DispatchQueue.main.async {
            XCTAssertEqual(sut.isPodcastFavourite, true)
            XCTAssertEqual(sut.buttonFavourite.currentTitle, "Favourited")
            exp.fulfill()
        }
        cache.completefavouriteActionWith(result: .success(true))

        wait(for: [exp], timeout: 1)
    }
    
    
    
    private func makeSUT(with model: Podcast) -> (PodcastDetailViewController, ImageLoaderSpy, CacheStoreSpy){
        let storyboard = UIStoryboard(name: "Podcast", bundle: Bundle(identifier: "com.heyhub.PodcastsFeed"))
        let sut = storyboard.instantiateViewController(identifier: "PodcastDetailViewController") as! PodcastDetailViewController
        let imageLoaderSpy = ImageLoaderSpy()
        sut.imageLoader = imageLoaderSpy
        let cacheStoreSpy = CacheStoreSpy()
        let podcastSpy = PodcastCache(cacheStore: cacheStoreSpy)
        sut.podcastCache = podcastSpy
        sut.model = model
        
        return (sut, imageLoaderSpy, cacheStoreSpy)
        
    }
    
    private class ImageLoaderSpy: ImageLoader{
        var arrayCompletion = [(Result<Data, Error>) -> Void]()
        
        func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            arrayCompletion.append(completion)
        }
        
        func completeImageLoadingWith(error: Error, at index: Int = 0){
            arrayCompletion[index](.failure(error))
        }
        
        func completeImageLoadingWith(data: Data, at index: Int = 0){
            arrayCompletion[index](.success(data))
        }
        
    }
    
    private class CacheStoreSpy: CacheStore{
        var arrayCompletion = [(PodcastsFeed.CacheStoreResult) -> Void]()
        func checkForFavourite(_ id: String, completion: @escaping (PodcastsFeed.CacheStoreResult) -> Void) {
            arrayCompletion.append(completion)
        }
        
        func favouriteAction(_ id: String, completion: @escaping (PodcastsFeed.CacheStoreResult) -> Void) {
            arrayCompletion.append(completion)

        }
        
        func completeCheckForFavouriteWith(result: PodcastsFeed.CacheStoreResult, at index: Int = 0){
            arrayCompletion[index](result)
        }
        
        func completefavouriteActionWith(result: PodcastsFeed.CacheStoreResult, at index: Int = 0){
            arrayCompletion[index](result)
        }
        
        
    }
    func makePodcast(title: String, description: String, isFavourite: Bool = false) -> Podcast{
        let id = UUID().uuidString
        if isFavourite{
            UserDefaults.standard.set(true, forKey: id)
        }
           return Podcast(title: title, description: description, id: id, imageURL: anyURL(), thumbnailURL: anyURL(), publisher: "Some publisher")
        }
    
    
    private func anyURL() -> URL{
        URL(string: "https://lumiere-a.akamaihd.net/v1/images/the-last-jedi-theatrical-poster-film-page_bca06283.jpeg")!
    }

}

private extension PodcastDetailViewController{
    var isPodcastFavourite: Bool?{
        return buttonFavourite.currentTitle == "Favourited"
    }
    
    var titlePodcast: String?{
        return labelTitle.text
    }
    var author: String?{
        return labelAuthor.text
    }
    var descriptionPodcast: String?{
        return labelDescription.text
    }
    
    var imagePodcastData: Data?{
        return imagePodcast.image?.pngData()
    }
}
