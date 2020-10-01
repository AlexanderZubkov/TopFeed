//
//  Constants.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

enum Constants {

    struct API {
        static let limit = 20
        static let baseURL = "https://www.reddit.com/top.json?limit=\(Constants.API.limit)"
    }
    static let errorMessage = "Something went wrong. Please try again later."
    static let baseFont = UIFont.systemFont(ofSize: 17)
}
