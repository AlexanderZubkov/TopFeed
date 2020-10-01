//
//  UITableView+Extensions.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 01.10.2020.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        let name = String(describing: cell.self)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    func dequeueCell<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
