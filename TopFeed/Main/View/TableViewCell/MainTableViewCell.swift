//
//  MainTableViewCell.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

protocol MainTableViewCellDelegate: class {
    func loadAction(with imageURL: URL, and externalURL: URL)
}

class MainTableViewCell: UITableViewCell {

    private weak var delegate: MainTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbnail: CacheableImageView!
    @IBOutlet weak var commentsLabel: UILabel!

    private var viewModel: MainTableViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        userLabel.text = nil
        commentsLabel.text = nil
        thumbnail.image = nil
    }

    public func configure(with viewModel: MainTableViewCellViewModel, delegate: MainTableViewCellDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate

        titleLabel.text = viewModel.title
        userLabel.text = viewModel.author
        commentsLabel.text = viewModel.comments
        guard let externalURL = viewModel.post.imageURL else {
            imageContainer.isHidden = true
            return
        }

        imageContainer.isHidden = false

        DispatchQueue.main.async {
            self.addGestureRecognizer()
        }
        thumbnail.loadImage(with: viewModel.post.thumbnail, externalURL: externalURL) { added in
        }
    }

    private func addGestureRecognizer() {
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        self.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func handleGesture() {
        guard let url = viewModel?.post.thumbnail,
              let imageURL = URL(string: url.preparedForURL),
              let external = viewModel?.post.imageURL,
              let externalURL = URL(string: external.preparedForURL) else {
            return
        }

        delegate?.loadAction(with: imageURL, and: externalURL)
    }
}
