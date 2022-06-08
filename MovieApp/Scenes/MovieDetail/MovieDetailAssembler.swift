//
//  MovieDetailAssembler.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Reusable
import UIKit

protocol MovieDetailAssembler {
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewController
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewModel
    func resolve(navigationController: UINavigationController) -> MovieDetailNavigatorType
    func resolve() -> MovieDetailUseCaseType
}

extension MovieDetailAssembler {
    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewController {
        let vc = MovieDetailViewController.instantiate()
        let vm: MovieDetailViewModel = resolve(navigationController: navigationController,
                                               movie: movie)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, movie: Movie) -> MovieDetailViewModel {
        return MovieDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            movie: movie
        )
    }
}

extension MovieDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MovieDetailNavigatorType {
        return MovieDetailNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> MovieDetailUseCaseType {
        return MovieDetailUseCase(movieGateway: resolve())
    }
}
