//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]?
    let response: String?
    let error: String?
    let totalResults: String?

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case response = "Response"
        case error = "Error"
        case totalResults
    }

    var isSuccess: Bool {
        return response == "True"
    }
}
