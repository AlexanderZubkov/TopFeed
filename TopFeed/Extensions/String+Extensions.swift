//
//  String+Extensions.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 01.10.2020.
//

import Foundation

extension String {
    var preparedForURL: String {
        replacingOccurrences(of: "&amp;", with: "&")
    }
}
