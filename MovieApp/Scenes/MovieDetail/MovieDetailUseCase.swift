//
//  MovieDetailUseCase.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Combine

protocol MovieDetailUseCaseType {
    func getMovieDetail(movieId: String) -> AnyPublisher<Movie?, Error>
}

struct MovieDetailUseCase: MovieDetailUseCaseType, GettingMovies {
    var movieGateway: MovieGatewayType
}
