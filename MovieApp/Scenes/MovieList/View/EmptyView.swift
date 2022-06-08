//
//  EmptyView.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import UIKit
import Reusable

final class EmptyView: UIView, NibLoadable {

    @IBOutlet weak var errorLabel: UILabel!

    var onTryAgain: (() -> Void)?

    func configView(error: String?) {
        errorLabel.text = error
    }

    @IBAction func onTryAgain(_ sender: Any) {
        onTryAgain?()
    }
}
