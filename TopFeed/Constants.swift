//
//  Constants.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

enum Constants {

    enum API {
        static let limit = 20
        static let baseURL = "https://www.reddit.com/top.json?limit=\(Constants.API.limit)"
    }
    static let errorMessage = "Something went wrong. Please try again later."
    static let baseFont = UIFont.systemFont(ofSize: 17)

    enum Main {
        static let pullToRefresh = "Pull to refresh"
        static let saveToPhotos = "Save to Photos"
        static let openInSafari = "Open in Safari"
        static let cancel = "Cancel"
    }
}
