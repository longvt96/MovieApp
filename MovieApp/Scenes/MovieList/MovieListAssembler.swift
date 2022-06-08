//
//  MovieListAssembler.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Reusable
import UIKit

protocol MovieListAssembler {
    func resolve(navigationController: UINavigationController) -> MovieListViewController
    func resolve(navigationController: UINavigationController) -> MovieListViewModel
    func resolve(navigationController: UINavigationController) -> MovieListNavigatorType
    func resolve() -> MovieListUseCaseType
}

extension MovieListAssembler {
    func resolve(navigationController: UINavigationController) -> MovieListViewController {
        let vc = MovieListViewController.instantiate()
        let vm: MovieListViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController) -> MovieListViewModel {
        return MovieListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension MovieListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MovieListNavigatorType {
        return MovieListNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> MovieListUseCaseType {
        return MovieListUseCase(movieGateway: resolve())
    }
}
