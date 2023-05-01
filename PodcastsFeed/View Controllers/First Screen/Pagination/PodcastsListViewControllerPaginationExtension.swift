//
//  PodcastsListViewControllerExtension.swift
//  PodcastsFeed
//
//  Created by Nav on 01/05/23.
//

import Foundation
import UIKit

extension PodcastsListViewController{
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrolledToBottom(scrollView) && Pagination.canLoadMore{
            podcastLoader?.load()
        }
    }
    private func scrolledToBottom(_ scrollView: UIScrollView) -> Bool{
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) && scrollView ==  tableView
        {
            return true
        }
        return false
    }
}
