//
//  MovieListNavigator.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import UIKit

protocol MovieListNavigatorType {
    func toMovieDetail(movie: Movie)
}

struct MovieListNavigator: MovieListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController

    func toMovieDetail(movie: Movie) {
        let vc: MovieDetailViewController = assembler.resolve(navigationController: navigationController,
                                                              movie: movie)
        navigationController.pushViewController(vc, animated: true)
    }
}
