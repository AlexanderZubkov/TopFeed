//
//  APIClient.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import Foundation

protocol APIClientPostProtocol {
    func loadPosts(after name: String?, completion: @escaping (Result<[Object], APIError>) -> Void)
}

// Workaround to allow default argument.
extension APIClientPostProtocol {
    func loadPosts(completion: @escaping (Result<[Object], APIError>) -> Void) {
        loadPosts(after: nil, completion: completion)
    }
}

protocol APIClientImageProtocol {
    func loadImage(with url: URL, completion: @escaping (Data?) -> Void)
}

enum APIError: Error {
    case wrongURL
    case requestError(String)
    case noData
    case decodingError
}

struct APIClient: APIClientPostProtocol, APIClientImageProtocol {
    func loadPosts(after name: String?, completion: @escaping (Result<[Object], APIError>) -> Void) {
        var urlString = Constants.API.baseURL
        if let name = name {
            urlString += "&after=\(name)"
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(.wrongURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.requestError(error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(decoded.posts))
            }
            catch let error {
                completion(.failure(.decodingError))
                debugPrint("decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func loadImage(with url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data)
        }
        task.resume()
    }
}
