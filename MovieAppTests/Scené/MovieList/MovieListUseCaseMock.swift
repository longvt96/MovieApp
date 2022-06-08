//
//  MovieListUseCaseMock.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp
import Combine

final class MovieListUseCaseMock: MovieListUseCaseType {

    // MARK: - getMovieList

    var getMovieListCalled = false
    var getMovieListReturnValue = Future<MovieResponse?, Error> { promise in
        promise(.success(MovieResponse(movies: [Movie()], response: "True", error: nil, totalResults: nil)))
    }
    .eraseToAnyPublisher()

    func getMovieList(keyword: String, page: Int) -> AnyPublisher<MovieResponse?, Error> {
        getMovieListCalled = true
        return getMovieListReturnValue
    }
}
