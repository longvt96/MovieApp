//
//  API+Movie.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import Alamofire
import Combine

// MARK: - GetMovieList
extension API {
    func getMovieList(_ input: GetMovieListInput) -> AnyPublisher<GetMovieListOutput, Error> {
        let result: AnyPublisher<MovieResponse, Error> = request(input)
        return result
            .map { GetMovieListOutput(response: $0) }
            .eraseToAnyPublisher()
    }
    
    final class GetMovieListInput: APIInput {
        init(keyword: String, page: Int) {
            let params: Parameters = [
                "s": keyword,
                "page": page,
                "apikey": APIKey.key,
                "type": "Movie"
            ]
            
            super.init(urlString: API.Urls.getMovieData,
                       parameters: params,
                       method: .get,
                       requireAccessToken: false)
        }
    }
    
    final class GetMovieListOutput {
        let response: MovieResponse
        
        init(response: MovieResponse) {
            self.response = response
        }
    }
}

// MARK: - GetMovieDetail
extension API {
    func getMovieDetail(_ input: GetMovieDetailInput) -> AnyPublisher<GetMovieDetailOutput, Error> {
        let result: AnyPublisher<Movie, Error> = request(input)
        return result
            .map { GetMovieDetailOutput(movie: $0) }
            .eraseToAnyPublisher()
    }
    
    final class GetMovieDetailInput: APIInput {
        init(movieId: String) {
            let params: Parameters = [
                "i": movieId,
                "apikey": APIKey.key
            ]
            
            super.init(urlString: API.Urls.getMovieData,
                       parameters: params,
                       method: .get,
                       requireAccessToken: false)
        }
    }
    
    final class GetMovieDetailOutput {
        let movie: Movie
        
        init(movie: Movie) {
            self.movie = movie
        }
    }
}
