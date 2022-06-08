//
//  UIViewController+Debug.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import UIKit

extension UIViewController {
    public func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
