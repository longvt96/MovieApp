//
//  Double+.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

extension Double {
    var currency: String {
        return String(format: "$%.02f", self)
    }
}
