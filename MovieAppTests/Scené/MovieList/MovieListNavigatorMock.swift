//
//  MovieListNavigatorMock.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp

final class MovieListNavigatorMock: MovieListNavigatorType {

    // MARK: - toMovieDetail

    var toMovieDetailCalled = false

    func toMovieDetail(movie: Movie) {
        toMovieDetailCalled = true
    }
}
