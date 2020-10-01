//
//  Post.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import Foundation

// Global object returned by api request.
struct Post: Decodable {
    let data: PostData

    var posts: [Object] {
        data.children.map( \.data)
    }
}

struct PostData: Decodable {
    let children: [PostDataChild]
}

struct PostDataChild: Decodable {
    let data: Object
}

// Object to be used around the app.
struct Object: Decodable {
    let author: String
    let title: String
    let thumbnail: String
    let created: Int
    let num_comments: Int
    let name: String
    let preview: Preview?

    struct Preview: Decodable {
        let images: [ImageObject]

        struct ImageObject: Decodable {
            let source: ImageSource

            struct ImageSource: Decodable {
                let url: String
            }
        }
    }

    var imageURL: String? {
        preview?.images.first?.source.url
    }
}
