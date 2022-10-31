// MovieList.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// MovieList model.
struct MovieList: Decodable {
    let movies: [Movie]

    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

/// Extension for movie.
extension MovieList {
    struct Movie: Decodable {
        let id: Int
        let overview: String
        let posterPath: String
        let releaseDate: String
        let title: String
        let voteAverage: Double

        private enum CodingKeys: String, CodingKey {
            case id, overview, title
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
        }
    }
}
