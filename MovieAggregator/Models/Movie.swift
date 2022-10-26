// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// MovieList.
struct MovieList: Codable {
    let results: [Movie]
}

/// Movies model.
struct Movie: Codable {
    let id: Int
    let overview: String
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
