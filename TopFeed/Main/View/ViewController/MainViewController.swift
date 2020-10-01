//
//  MainViewController.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: MainViewControllerViewModel?
    private lazy var refreshControl = UIRefreshControl()
    private var currentNumberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        viewModel?.delegate = self
        viewModel?.reloadPosts()
    }

    private func prepareUI() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        tableView.register(cell: MainTableViewCell.self)
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel?.reloadPosts()
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueCell(at: indexPath)
        cell.selectionStyle = .none
        if let cellViewModel = viewModel?.viewModelForCell(at: indexPath.row) {
            cell.configure(with: cellViewModel, delegate: self)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel?.heightForRow(at: indexPath.row, for: UIScreen.main.bounds.width) ?? 0
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let viewModel = viewModel,
              indexPaths.contains(where: { $0.row > (viewModel.posts.count - 5) }) else {
            return
        }

        viewModel.loadMorePosts()
    }
}

//MARK: - MainViewControllerViewModelDelegate
extension MainViewController: MainViewControllerViewModelDelegate {
    func postsReloaded() {
        currentNumberOfRows = viewModel?.posts.count ?? 0
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    func addedPosts() {
        guard let newRowsNumber = viewModel?.posts.count else {
            return
        }

        let difference = newRowsNumber - currentNumberOfRows
        guard difference > 0 else {
            return
        }

        var array: [IndexPath] = []
        for i in 0..<difference {
            let indexPath = IndexPath(row: currentNumberOfRows + i, section: 0)
            array.append(indexPath)
        }

        DispatchQueue.main.async {
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: array, with: .automatic)
            }) { (success) in
                self.currentNumberOfRows = self.viewModel?.posts.count ?? 0
            }
        }
    }

    func gotError(_ error: String) {
        showAlert(title: nil, message: error)
    }
}

//MARK: - MainTableViewCellDelegate
extension MainViewController: MainTableViewCellDelegate {
    func loadAction(with imageURL: URL, and externalURL: URL) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Save to Photos", style: .default, handler: { (_) in
            self.viewModel?.saveImage(with: imageURL, completion: { (data) in
                guard let data = data,
                      let image = UIImage(data: data) else {
                    return
                }

                DispatchQueue.main.async() {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            })
        }))
        action.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
            UIApplication.shared.open(externalURL)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        DispatchQueue.main.async {
            self.present(action, animated: true)
        }
    }
}
