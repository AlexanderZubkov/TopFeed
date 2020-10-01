//
//  MainTableViewCellViewModel.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import Foundation


struct MainTableViewCellViewModel {

    public let post: Object
    private let formatter = RelativeDateTimeFormatter()

    var title: String {
        post.title
    }

    var author: String {
        let created = post.created
        let date = Date(timeIntervalSince1970: TimeInterval(created))
        let stringDate = formatter.localizedString(for: date, relativeTo: Date())

        return "\(post.author) posted \(stringDate)"
    }

    var comments: String {
        "Comments: \(post.num_comments)"
    }
}
