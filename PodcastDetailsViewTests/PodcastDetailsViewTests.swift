//
//  PodcastDetailsViewTests.swift
//  PodcastDetailsViewTests
//
//  Created by Nav on 27/04/23.
//

import XCTest
@testable import PodcastsFeed

final class PodcastDetailsViewTests: XCTestCase {

    func test_initial(){
        let podcast = makePodcast(title: "Some Podcast", description: "Some description", isFavourite: true)
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        sut.model = podcast
        XCTAssertEqual(sut.isFavourite, false)
        
        
    }
    
    func makeSUT() -> PodcastDetailViewController{
        let storyboard = UIStoryboard(name: "Podcast", bundle: Bundle(identifier: "com.heyhub.PodcastsFeed"))
                let sut = storyboard.instantiateViewController(identifier: "ArtistDetailViewController") as! PodcastDetailViewController
        return sut
        
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

private extension PodcastDetailViewController{
    var isFavourite: Bool?{
        return buttonFavourite.currentTitle == "Favourited"
    }
}
