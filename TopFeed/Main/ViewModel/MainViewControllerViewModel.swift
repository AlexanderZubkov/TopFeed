//
//  MainViewControllerViewModel.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import Foundation
import CoreGraphics

protocol MainViewControllerViewModelDelegate: class {
    func postsReloaded()
    func addedPosts()
    func gotError(_ error: String)
}

class MainViewControllerViewModel {

    public weak var delegate: MainViewControllerViewModelDelegate?
    public var posts: [Object] = []
    private let client = APIClient()
    private var isLoading = false

    private let sideOffset: CGFloat = 20
    private let verticalOffset: CGFloat = 10
    private let labelHeight: CGFloat = 17
    private let imageHeight: CGFloat = 140

    public func reloadPosts() {
        guard !isLoading else {
            return
        }

        isLoading = true
        client.loadPosts() { [weak self] (result) in
            guard let self = self else {
                return
            }

            self.isLoading = false
            switch result {
            case .success(let objects):
                self.posts = objects
                self.delegate?.postsReloaded()
            case .failure(_):
                self.delegate?.gotError(Constants.errorMessage)
            }
        }
    }

    public func loadMorePosts() {
        guard !isLoading else {
            return
        }

        guard posts.count > 0, let lastPost = posts.last else {
            reloadPosts()
            return
        }

        isLoading = true
        client.loadPosts(after: lastPost.name) { [weak self] (result) in
            guard let self = self else {
                return
            }

            self.isLoading = false
            switch result {
            case .success(let objects):
                self.posts.append(contentsOf: objects)
                self.delegate?.addedPosts()
            case .failure(_):
                self.delegate?.gotError(Constants.errorMessage)
            }
        }
    }

    func heightForRow(at index: Int, for screenWidth: CGFloat) -> CGFloat {
        let post = posts[index]
        let attributed = NSAttributedString(string: post.title,
                                            attributes: [NSAttributedString.Key.font: Constants.baseFont])
        let height = attributed.height(for: screenWidth - sideOffset * 2)
        var actualImageHeight: CGFloat = 0
        if post.imageURL != nil {
            actualImageHeight = imageHeight
        }
        return verticalOffset * 5 + height + labelHeight * 2 + actualImageHeight
    }

    func viewModelForCell(at index: Int) -> MainTableViewCellViewModel {
        MainTableViewCellViewModel(post: posts[index])
    }

    func saveImage(with url: URL, completion: @escaping (Data?) -> Void) {
        client.loadImage(with: url) { (data) in
            completion(data)
        }
    }
}
