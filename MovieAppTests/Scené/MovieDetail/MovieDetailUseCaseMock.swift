//
//  MovieDetailUseCaseMock.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp
import Combine

final class MovieDetailUseCaseMock: MovieDetailUseCaseType {

    // MARK: - getMovieDetail

    var getMovieDetailCalled = false
    var getMovieDetailReturnValue = Future<Movie?, Error> { promise in
        promise(.success(Movie()))
    }
    .eraseToAnyPublisher()

    func getMovieDetail(movieId: String) -> AnyPublisher<Movie?, Error> {
        getMovieDetailCalled = true
        return getMovieDetailReturnValue
    }
}
