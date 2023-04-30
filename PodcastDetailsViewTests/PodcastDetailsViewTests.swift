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
        let (sut, loader) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isFavourite, false)
        
    }
    
    
    func test_viewDidLoad_checksValuesOnLabel(){
        let podcast = makePodcast(title: "Some Podcast", description: "Some description", isFavourite: false)
        let (sut, loader) = makeSUT(with: podcast)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isFavourite, false)
        XCTAssertEqual(sut.titlePodcast, podcast.title)
        XCTAssertEqual(sut.descriptionPodcast, podcast.description)

        
    }
    
    
    func test_loadsImageSuccessfullyFromBackend(){
        let podcast = makePodcast(title: "Star wars", description: "Star wars podcast")
        let (sut, loader) = makeSUT(with: podcast)
        let imageStarWars = UIImage(named: "starwars.png")
        sut.loadViewIfNeeded()
        let exp = expectation(description: "wait for image to complete")
        sut.imageLoader?.loadImageData(from: podcast.imageURL){_ in }
        loader.completeImageLoadingWith(data: imageStarWars!.pngData()!)
        DispatchQueue.main.async {
            XCTAssertEqual(sut.imagePodcastData, imageStarWars?.pngData())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
   private func makeSUT(with model: Podcast) -> (PodcastDetailViewController, ImageLoaderSpy){
        let storyboard = UIStoryboard(name: "Podcast", bundle: Bundle(identifier: "com.heyhub.PodcastsFeed"))
                let sut = storyboard.instantiateViewController(identifier: "PodcastDetailViewController") as! PodcastDetailViewController
        let imageLoaderSpy = ImageLoaderSpy()
        sut.imageLoader = imageLoaderSpy
        sut.model = model

        return (sut, imageLoaderSpy)
        
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
    var isFavourite: Bool?{
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
