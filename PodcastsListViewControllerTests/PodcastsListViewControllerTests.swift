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
    
    
    func makeSUT() -> (PodcastsListViewController, LoaderSpy){
        let loader = LoaderSpy()
        let sut = PodcastsListViewController(loader: loader)
        return (sut, loader)
    }
    class LoaderSpy: PodcastLoader{
        func load(completion: @escaping (PodcastLoaderResult) -> Void) {
            loadCallCount += 1
        }
        
        var loadCallCount = 0
        
    }
   
}
