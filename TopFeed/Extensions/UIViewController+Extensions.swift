//
//  UIViewController+Extensions.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

extension UIViewController {

    // To get new instance from it's storyboard.
    // StoryboardID should be equal to the class name.
    static func instance() -> Self {
        let identifier = String(describing: self)
        let story = UIStoryboard(name: identifier, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: identifier)
        return vc as! Self
    }

    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
