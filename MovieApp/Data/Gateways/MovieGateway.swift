//
//  MovieGateways.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import Combine

protocol MovieGatewayType {
    func getMovieList(keyword: String, page: Int) -> AnyPublisher<MovieResponse?, Error>
    func getMovieDetail(movieId: String) -> AnyPublisher<Movie?, Error>
}

struct MovieGateway: MovieGatewayType {
    func getMovieList(keyword: String, page: Int) -> AnyPublisher<MovieResponse?, Error> {
        let input = API.GetMovieListInput(keyword: keyword, page: page)
        
        return API.shared.getMovieList(input)
            .map {
                $0.response
            }
            .eraseToAnyPublisher()
    }

    func getMovieDetail(movieId: String) -> AnyPublisher<Movie?, Error> {
        let input = API.GetMovieDetailInput(movieId: movieId)
        
        return API.shared.getMovieDetail(input)
            .map {
                $0.movie
            }
            .eraseToAnyPublisher()
    }
}
