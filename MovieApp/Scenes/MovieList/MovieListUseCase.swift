//
//  MovieListUseCase.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Combine

protocol MovieListUseCaseType {
    func getMovieList(keyword: String, page: Int) -> AnyPublisher<MovieResponse?, Error>
}

struct MovieListUseCase: MovieListUseCaseType, GettingMovies {
    var movieGateway: MovieGatewayType
}
