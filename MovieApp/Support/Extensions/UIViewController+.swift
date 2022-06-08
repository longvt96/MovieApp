//
//  UIViewController+.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ alert: AlertMessage, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: alert.title,
                                   message: alert.message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func showError(_ error: Error, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error",
                                   message: error.localizedDescription,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}
