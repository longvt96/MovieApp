//
//  MovieDetailNavigator.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import UIKit

protocol MovieDetailNavigatorType {

}

struct MovieDetailNavigator: MovieDetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}