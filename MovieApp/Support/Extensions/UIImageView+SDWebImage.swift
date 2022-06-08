//
//  UIImageView+SDWebImage.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with url: URL?, completion: (() -> Void)? = nil) {
        self.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached) { (_, _, _, _) in
            completion?()
        }
    }
}
