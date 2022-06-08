//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Combine

struct MovieDetailViewModel {
    let navigator: MovieDetailNavigatorType
    let useCase: MovieDetailUseCaseType
    let movie: Movie
}

// MARK: - ViewModel
extension MovieDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let seeMoreTrigger: Driver<Void>
    }

    final class Output: ObservableObject {
        @Published var movie: Movie?
        @Published var isExpandContent = false
        @Published var isLoading = false
    }

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let loadingActivityTracker = ActivityTracker(false)

        output.movie = movie

        input.loadTrigger
            .flatMap { _ -> Driver<Movie?> in
                guard let movieId = movie.imdbID else {
                    return Driver.empty()
                }
                return useCase.getMovieDetail(movieId: movieId)
                    .trackActivity(loadingActivityTracker)
                    .asDriver()
            }
            .assign(to: \.movie, on: output)
            .store(in: cancelBag)

        input.seeMoreTrigger
            .sink { _ in
                output.isExpandContent.toggle()
            }
            .store(in: cancelBag)

        loadingActivityTracker
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)

        return output
    }
}
