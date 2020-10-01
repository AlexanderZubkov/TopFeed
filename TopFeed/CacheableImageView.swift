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
    private var imageURL: String?
    private let client: APIClientImageProtocol = APIClient()
    private var externalURL: String?

    func loadImage(with urlString: String, externalURL: String, completion: @escaping (Bool) -> Void) {

        // Image won't be loaded unless extra symbols are removed from url.
        let preparedString = urlString.preparedForURL
        let preparedExternalString = externalURL.preparedForURL
        guard let url = URL(string: preparedString) else {
            completion(false)
            return
        }

        imageURL = preparedString
        self.externalURL = preparedExternalString
        let nsString = preparedString as NSString

        if let image = cache.object(forKey: nsString) {
            self.image = image
            completion(true)
            return
        }

        client.loadImage(with: url) { [weak self] (data) in
            guard let self = self,
                  let data = data,
                  let newImage = UIImage(data: data) else {
                completion(false)
                return
            }

            cache.setObject(newImage, forKey: nsString)
            if self.imageURL == preparedString {
                DispatchQueue.main.async {
                    self.image = newImage
                }
                completion(true)
            }
        }
    }
}
