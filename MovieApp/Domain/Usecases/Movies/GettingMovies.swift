//
//  GettingMovies.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import Combine

protocol GettingMovies {
    var movieGateway: MovieGatewayType { get }
}

extension GettingMovies {
    func getMovieList(keyword: String, page: Int) -> AnyPublisher<MovieResponse?, Error> {
        movieGateway.getMovieList(keyword: keyword, page: page)
    }

    func getMovieDetail(movieId: String) -> AnyPublisher<Movie?, Error> {
        movieGateway.getMovieDetail(movieId: movieId)
    }
}
