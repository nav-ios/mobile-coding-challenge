//
//  UserDefaultsCacheStoreReset.swift
//  PodcastsFeed
//
//  Created by Nav on 03/05/23.
//

import Foundation

extension UserDefaultsCacheStore {
    static func resetDefaults() {
        if let bundleID = Bundle(identifier: "com.heyhub.PodcastsFeed")?.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
