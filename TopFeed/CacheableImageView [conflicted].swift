//
//  CacheableImageView.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

class CacheableImageView: UIImageView {

    // imageURL will be used to define if setting image is still needed.
    var imageURL: String?

    func loadImage(with urlString: String) {

        // Image won't be loaded unless extra symbols are removed from url.
        let preparedString = urlString.replacingOccurrences(of: "&amp;", with: "&")
        guard let url = URL(string: preparedString), let nsString = preparedString as? NSString else {
            return
        }

        imageURL = preparedString

        if let image = cache.object(forKey: nsString) {
            self.image = image
            return
        }
        
    }

}
