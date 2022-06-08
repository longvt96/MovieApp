//
//  Movie.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import Foundation

struct Movie: Decodable {
    let title, year, rated, released: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards: String?
    let poster: String?
    let ratings: [MovieRating]?
    var imdbID: String?
    let metascore, imdbRating, imdbVotes: String?
    let type, dvd, boxOffice, production: String?
    let website, response: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }

    init() {
        title = nil
        year = nil
        rated = nil
        released = nil
        runtime = nil
        genre = nil
        director = nil
        writer = nil
        actors = nil
        plot = nil
        language = nil
        country = nil
        awards = nil
        poster = nil
        ratings = nil
        metascore = nil
        imdbRating = nil
        imdbVotes = nil
        imdbID = nil
        type = nil
        dvd = nil
        boxOffice = nil
        production = nil
        website = nil
        response = nil
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.imdbID == rhs.imdbID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}

struct MovieRating: Codable {
    let source, value: String?

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
