//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Combine
import CombineExt

struct MovieListViewModel {
    let navigator: MovieListNavigatorType
    let useCase: MovieListUseCaseType
}

// MARK: - ViewModel
extension MovieListViewModel: ViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectedTrigger: Driver<IndexPath>
    }

    final class Output: ObservableObject {
        @Published var movies: [Movie] = []
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var isLoadingMore = false
        @Published var alert = AlertMessage()
        @Published var errorMessage: String?
    }

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        let loadingActivityTracker = ActivityTracker(false)
        let reloadingActivityTracker = ActivityTracker(false)
        let loadingMoreActivityTracker = ActivityTracker(false)
    
        let pageSubject = CurrentValueSubject<Int, Never>(1)

        // Load data

        input.searchTrigger
            .flatMap {
                useCase.getMovieList(keyword: $0 ?? "", page: 1)
                    .trackError(errorTracker)
                    .trackActivity(loadingActivityTracker)
                    .asDriver()
            }
            .sink {
                guard $0?.isSuccess == true else {
                    output.errorMessage = $0?.error
                    output.movies = []
                    return
                }
                pageSubject.send(2)
                output.movies = $0?.movies ?? []
                output.errorMessage = nil
            }
            .store(in: cancelBag)

        // Reload

        input.reloadTrigger
            .withLatestFrom(input.searchTrigger)
            .flatMap {
                useCase.getMovieList(keyword: $0 ?? "", page: 1)
                    .trackError(errorTracker)
                    .trackActivity(reloadingActivityTracker)
                    .asDriver()
            }
            .sink {
                guard $0?.isSuccess == true else {
                    output.errorMessage = $0?.error
                    output.movies = []
                    return
                }
                pageSubject.send(2)
                output.movies = $0?.movies ?? []
                output.errorMessage = nil
            }
            .store(in: cancelBag)

        // LoadMore

        input.loadMoreTrigger
            .withLatestFrom(input.searchTrigger)
            .flatMap {
                useCase.getMovieList(keyword: $0 ?? "", page: pageSubject.value)
                    .trackError(errorTracker)
                    .trackActivity(loadingMoreActivityTracker)
                    .asDriver()
            }
            .sink {
                guard $0?.isSuccess == true else {
                    return
                }
                pageSubject.value = pageSubject.value + 1
                output.movies.append(contentsOf: $0?.movies ?? [])
            }
            .store(in: cancelBag)

        // Error

        errorTracker
            .receive(on: RunLoop.main)
            .map { AlertMessage(error: $0) }
            .assign(to: \.alert, on: output)
            .store(in: cancelBag)

        // Loading

        loadingActivityTracker
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        reloadingActivityTracker
            .assign(to: \.isReloading, on: output)
            .store(in: cancelBag)
        
        loadingMoreActivityTracker
            .assign(to: \.isLoadingMore, on: output)
            .store(in: cancelBag)

        // To Movie detail

        input.selectedTrigger
            .sink {
                navigator.toMovieDetail(movie: output.movies[$0.row])
            }
            .store(in: cancelBag)

        return output
    }
}
