// MovieDetail.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Model for detail information about film.
struct MovieDetail: Decodable {
    let backdropPath: String
    let posterPath: String
    let title: String
    let runtime: Int
    let voteAverage: Double
    let imdbId: String
    let releaseDate: String
    let genres: [Genres]
    let overview: String

    private enum CodingKeys: String, CodingKey {
        case title, runtime, genres, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case imdbId = "imdb_id"
        case releaseDate = "release_date"
    }
}

/// Extension with genres.
extension MovieDetail {
    struct Genres: Decodable {
        let name: String
    }
}
